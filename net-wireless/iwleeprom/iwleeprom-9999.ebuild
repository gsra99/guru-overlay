# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit subversion eutils

DESCRIPTION=""
HOMEPAGE=""
RESTRICT="mirror"
ESVN_REPO_URI="https://code.google.com/p/${PN}/source/browse/#svn%2Fbranches%2Fatheros"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

src_unpack() {
	subversion_src_unpack
}

src_install () {
	doman ${S}/${PN}.8.gz
	dosbin ${S}/${PN}
	fperms 4755 /usr/sbin/iwleeprom
}
