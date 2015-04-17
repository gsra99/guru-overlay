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
	cd "${S}/usr/share"
	insinto /usr/share/applications
	doins applications/urserver.desktop
	insinto /usr/share/icons
	doins icons/urserver.png
	insinto /usr/share/icons/hicolor/48x48/apps
	doins icons/hicolor/48x48/apps/urserver.png
	insinto /usr/share/icons/hicolor/72x72/apps
	doins icons/hicolor/72x72/apps/urserver.png
	insinto /usr/share/icons/hicolor/96x96/apps
	doins icons/hicolor/96x96/apps/urserver.png
	insinto /usr/share/pixmaps
	doins pixmaps/urserver.png
	dodir /opt/urserver
	cd "${S}/opt/urserver"
	insinto /opt/urserver
	doins urserver
	doins urserver-autostart.desktop
	doins urserver-start
	doins urserver-stop
	dodir /opt/urserver/manager
	insinto /opt/urserver/manager
	doins manager/*.css
	doins manager/*.html
	doins manager/*.js
}
