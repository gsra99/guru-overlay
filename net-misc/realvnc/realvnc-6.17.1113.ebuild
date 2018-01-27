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

inherit rpm

S="${WORKDIR}"
