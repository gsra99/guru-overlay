# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit linux-info linux-mod eutils git-r3

DESCRIPTION=""
HOMEPAGE=""

EGIT_REPO_URI="https://github.com/gsra99/raid_linux_driver.git"

LICENSE=""
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

MY_S="driver_sdk/src"
PATCHES=(
	"${FILESDIR}/rcraid.patch"
	"${FILESDIR}/install.patch"
)

MODULE_NAMES="rcraid(misc:${S}:${S}/${MY_S})"

src_unpack() {
	git-r3_src_unpack
}

pkg_setup() {
	kernel_is -gt 5 3 9 && die "Kernels higher than 5.3.9 are not supported"
	linux-mod_pkg_setup
}

src_compile() {
	set_arch_to_kernel
	emake -C ${MY_S} KVERS="${KV_FULL}"
}

src_install() {
	linux-mod_src_install
}
