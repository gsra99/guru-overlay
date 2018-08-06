# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit flag-o-matic git-r3 udev linux-info linux-mod

DESCRIPTION="Kernel modules for anbox"
HOMEPAGE="http://anbox.io/"
EGIT_REPO_URI="https://github.com/anbox/anbox-modules"
EGIT_BRANCH="master"
EGIT_COMMIT="2a5ea7c88b60d563ded16164520b9a2520582669"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="-custom-cflags -debug systemd"
RESTRICT="debug? ( strip ) splitdebug !custom-cflags? ( installsources ) test"

DEPEND=""
RDEPEND="${DEPEND}"

#S="${WORKDIR}/${P}/kernel"

BUILD_TARGETS="all"
BUILD_TARGET_ARCH="${ARCH}"
MODULE_NAMES="ashmem_linux(misc:${S}/ashmem) binder_linux(misc:${S}/binder)"

pkg_setup() {
	linux-info_pkg_setup
	use debug && CONFIG_CHECK="
		FRAME_POINTER
		DEBUG_INFO
		!DEBUG_INFO_REDUCED
	" check_extra_config
	linux-mod_pkg_setup
	BUILD_PARAMS="KERNEL_SRC=${KV_DIR} O=${KV_OUT_DIR}"
}

src_prepare() {
	# Remove deprecated syntax from udev rule #
	sed -e 's/\sNAME="%k",\s/ /' \
		-i 99-anbox.rules \
		|| die

	for amod in ashmem binder; do
		sed -e '/^KERNEL_SRC/,/[^[:space:]]/{/^KERNEL_SRC/d;/^[[:space:]]*$/d}' \
			-e 's|\(\sV=\)0\(\s\)|\11 KBUILD_VERBOSE=1\2|' \
			-i "${WORKDIR}/${P}"/kernel/${amod}/Makefile || die
	done
	default
}

src_configure() {
	use custom-cflags || strip-flags
	use custom-cflags || use debug || filter-flags -g*
	filter-ldflags -Wl,*
	set_arch_to_kernel
	default
}

src_install() {
	linux-mod_src_install
	if use systemd; then
		insinto /usr/lib/modules-load.d/
		newins "${S}"/anbox.conf anbox.conf
	fi
	udev_dorules 99-anbox.rules
}

pkg_postinst() {
	linux-mod_pkg_postinst
	if use '!systemd'; then
		elog "For openrc-based installations, the system administrator should"
		elog "manually add \"binder_linux\" and \"ashmem_linux\" to /etc/conf.d/modules."
	fi
}
