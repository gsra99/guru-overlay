# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="VNC Viewer for Unix/Linux platforms"
HOMEPAGE="https://www.realvnc.com/en/"
SRC_URI="
amd64? ( https://downloads.realvnc.com/download/file/viewer.files/VNC-Viewer-${PV}-Linux-x64.rpm )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="mirror"

inherit rpm xdg-utils

RDEPEND="virtual/libcrypt:="

S="${WORKDIR}"

src_unpack() {
	rpm_unpack ${A}
	cd "${S}/usr/share/man/man1"
	gzip -d vncviewer.1.gz
}

src_install() {
	cd "${S}/usr/bin"
	dobin vncviewer

	cd "${S}/usr/share/doc/${PN}-vnc-viewer-${PV}".*
	dodoc *.txt

	cd "${S}/usr/share/man/man1"
	doman vncviewer.1

	cd "${S}/usr/share/icons/hicolor/48x48/apps"
	insinto /usr/share/icons/hicolor/48x48/apps
	doins vncviewer48x48.png

	cd "${S}/usr/share/icons/hicolor/48x48/mimetypes"
	insinto /usr/share/icons/hicolor/48x48/mimetypes
	doins *.png

	cd "${S}/usr/share/applications"
	insinto /usr/share/applications
	doins ${PN}-vncviewer-scheme.desktop
	doins ${PN}-vncviewer.desktop

	cd "${S}/usr/share/mime/packages"
	insinto /usr/share/mime/packages
	doins ${PN}-vncviewer.xml

	cd "${S}/usr/share/mimelnk/application"
	doins ${PN}-vncviewer-mime.desktop
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
}
