# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit subversion eutils

DESCRIPTION=""
HOMEPAGE=""
RESTRICT="mirror"
ESVN_REPO_URI="http://iwleeprom.googlecode.com/svn/branches/atheros/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

src_unpack() {
	subversion_src_unpack
}

src_prepare() {
	epatch -p1 "${FILESDIR}/makefile.patch"
}

src_install () {
	local i
	for i in iwleeprom ; do
		doman ${i}/${i}.8.
		dosbin ${i}/${i}
	done
	fperms u+s-w /usr/sbin/iwleeprom
}
