# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit linux-info linux-mod eutils git-r3

DESCRIPTION=""
HOMEPAGE=""

EGIT_REPO_URI="https://github.com/thopiekar/rcraid-dkms.git"

LICENSE=""
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

MY_S="src"
MODULE_NAMES="rcraid(misc:${S}:${S}/${MY_S})"

PATCHES=(
	"${FILESDIR}/Makefile.patch"
)

src_unpack() {
	git-r3_src_unpack
}

pkg_setup() {
	kernel_is -gt 5 4 9 && die "Kernels higher than 5.4.9 are not supported"
	linux-mod_pkg_setup
}

src_compile() {
	set_arch_to_kernel
	emake -C ${MY_S} KVERS="${KV_FULL}"
}

src_install() {
	linux-mod_src_install
}
