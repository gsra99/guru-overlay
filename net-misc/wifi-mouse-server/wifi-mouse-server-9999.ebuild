# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit git-r3 cmake-utils eutils

DESCRIPTION=""
HOMEPAGE=""
EGIT_REPO_URI="https://github.com/gsra99/wifi-mouse.git"

LICENSE=""
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="x11-libs/libX11
	x11-libs/libXtst
	x11-libs/gtk+:2"
RDEPEND="${DEPEND}"

src_unpack() {
	git-r3_src_unpack
}

src_configure () {
	cmake-utils_src_configure -DCMAKE_INSTALL_PREFIX:PATH=/usr ..
}

#src_compile () {
#	cmake-utils_src_compile ..
#}
