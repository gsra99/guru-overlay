# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils

DESCRIPTION=""
HOMEPAGE=""
S="${WORKDIR}/mouseserver-sourcecode-Linux"
RESTRICT="mirror"
SRC_URI="http://wifimouse.necta.us/MSSourceForLinux.rar -> ${PN}.rar"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="app-arch/unrar"
RDEPEND="${DEPEND}"

src_unpack() {
	unrar -x "${A}" "${WORKDIR}"
	cd "${S}/src"
}
