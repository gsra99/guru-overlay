# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit git-r3 eutils

DESCRIPTION=""
HOMEPAGE=""
RESTRICT="mirror"
EGIT_REPO_URI="https://github.com/gsra99/iwleeprom.git"
EGIT_BRANCH="atheros"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

#src_unpack() {
#	subversion_src_unpack
#}

src_install () {
	doman ${S}/${PN}.8.gz
	dosbin ${S}/${PN}
	fperms 4755 /usr/sbin/iwleeprom
}
