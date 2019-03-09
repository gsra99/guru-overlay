# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="VNC Viewer for Unix/Linux platforms"
HOMEPAGE="https://www.realvnc.com/en/"
SRC_URI="
amd64? ( https://www.realvnc.com/download/file/viewer.files/VNC-Viewer-${PV}-Linux-x64.rpm )
x86? ( https://www.realvnc.com/download/file/viewer.files/VNC-Viewer-${PV}-Linux-x86.rpm )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
RESTRICT="mirror"

inherit rpm eutils

S="${WORKDIR}"
REVISION=38355

src_install() {
	cd "${S}/usr/bin"
	dobin vncviewer

	cd "${S}/usr/share/doc/${PN}-vnc-viewer-${PV}.${REVISION}"
	dodoc *.txt

	cd "${S}/usr/share/man/man1"
	doman vncviewer.1.gz

	cd "${S}/usr/share/icons/hicolor/48x48/apps"
	insinto /usr/share/icons/hicolor/48x48/apps
	doins vncviewer48x48.png

	cd "${S}/usr/share/icons/hicolor/48x48/mimetypes"
	insinto /usr/share/icons/hicolor/48x48/mimetypes
	doins *.png

	cd "${S}/usr/share/applications"
	insinto /usr/share/applications
	doins ${PN}-vncviewer.desktop

	cd "${S}/usr/share/mime/packages"
	insinto /usr/share/mime/packages
	doins ${PN}-vncviewer.xml
}
