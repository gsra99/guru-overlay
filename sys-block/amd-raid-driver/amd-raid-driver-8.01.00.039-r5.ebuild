# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit linux-info linux-mod eutils git-r3

DESCRIPTION=""
HOMEPAGE=""

EGIT_REPO_URI="https://github.com/thopiekar/rcraid-dkms.git"
EGIT_COMMIT="892c7b851d960b2f4d396273266726a973df693a"

LICENSE=""
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

#PATCHES=(
#	"${FILESDIR}/Makefile.patch"
#)

pkg_setup() {
	linux-info_pkg_setup
	kernel_is -ge 5 9 0 && die "Kernels 5.9.0 or higher are not supported"
	MODULE_NAMES="rcraid(misc:${S}:${S}/src)"
	BUILD_TARGETS="clean all"
	BUILD_PARAMS="-C src KVERS=${KV_FULL}"
	linux-mod_pkg_setup
}
