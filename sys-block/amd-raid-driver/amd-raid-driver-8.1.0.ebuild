# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit linux-info linux-mod eutils

DESCRIPTION=""
HOMEPAGE=""
MY_PV="${PV}-0~202012061007-pkg28~ubuntu21.04.1"
SRC_URI="https://launchpad.net/~thopiekar/+archive/ubuntu/rcraid/+sourcefiles/rcraid/${MY_PV}/rcraid_${MY_PV}.tar.xz"

LICENSE=""
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"
S="${WORKDIR}/${MY_PV}"

pkg_setup() {
	linux-info_pkg_setup
	kernel_is -ge 5 12 0 && die "Kernels 5.12.0 or higher are not supported"
	MODULE_NAMES="rcraid(misc:${S}:${S}/src)"
	BUILD_TARGETS="clean all"
	BUILD_PARAMS="-C src KVERS=${KV_FULL}"
	linux-mod_pkg_setup
}
