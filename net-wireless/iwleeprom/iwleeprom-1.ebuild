# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils

DESCRIPTION=""
HOMEPAGE=""
RESTRICT="mirror"
SRC_URI="https://storage.googleapis.com/google-code-archive-source/v2/code.google.com/${PN}/source-archive.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"
S="${WORKDIR}/${PN}/branches/atheros"

src_install () {
	doman ${S}/${PN}.8.gz
	dosbin ${S}/${PN}
	fperms 4755 /usr/sbin/iwleeprom
}
