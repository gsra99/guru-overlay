# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit git-r3 cmake-utils eutils

DESCRIPTION=""
HOMEPAGE=""
EGIT_REPO_URI="https://github.com/anoved/mmserver.git"

LICENSE=""
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="x11-libs/libX11
	x11-libs/libXtst
	x11-libs/gtk+:2
	dev-libs/libpcre
	net-dns/avahi
	x11-libs/libXmu
	x11-libs/libXt"
RDEPEND="${DEPEND}"

BUILD_DIR="${S}/build"

src_unpack() {
	git-r3_src_unpack
}

src_configure () {
	cmake-utils_src_configure ..
}
