# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit rpm

DESCRIPTION=""
HOMEPAGE=""
SRC_URI="https://www.unifiedremote.com/download/linux-x86-rpm -> ${PF}-x86.rpm"

LICENSE=""
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"
S=${WORKDIR}

src_unpack() {
	rpm_src_unpack ${A}
	cd "${S}"
}

src_install () {
	cd "${S}/opt"
	insinto /opt
	doins urserver
	cd "${S}/usr/share"
	insinto /usr/share
	doins applications/urserver.desktop
	doins icons/urserver.png
	doins icons/hicolor/48x48/apps/urserver.png
	doins icons/hicolor/72x72/apps/urserver.png
	doins icons/hicolor/96x96/apps/urserver.png
	doins pixmaps/urserver.png
}
