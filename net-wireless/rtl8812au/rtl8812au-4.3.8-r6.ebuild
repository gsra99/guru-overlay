# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit linux-info linux-mod eutils versionator

DESCRIPTION=""
HOMEPAGE=""
RELEASE_VERSION="6"
MODULE_NAMES="8812au(net/wireless:${S})"
S="${WORKDIR}/rtl8812AU-rtl8812AU-${PV}-${RELEASE_VERSION}"
SRC_URI="https://github.com/diederikdehaas/rtl8812AU/archive/rtl8812AU-${PV}-${RELEASE_VERSION}.tar.gz -> ${PF}.tar.gz"

LICENSE=""
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

src_unpack() {
	unpack ${A}
}

pkg_setup() {
	eselected=$(eselect kernel list | awk '/\*/ {print $2}' | awk 'gsub("linux-", "")')
	running=$(uname -r)
	if [ "$running" != "$eselected" ]; then
		die "Please ensure the eselected kernel source and running kernel are the same version, then try again."
	fi

        linux-mod_pkg_setup
        kernel_is -gt 4 2 && die "kernel higher than 4.2 is not supported"
}

src_compile() {
	set_arch_to_kernel
	KSRC="${KV_DIR}" KVER="${KV_FULL}" emake
}

src_install() {
	linux-mod_src_install
}
