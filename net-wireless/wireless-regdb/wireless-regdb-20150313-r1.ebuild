# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-wireless/wireless-regdb/wireless-regdb-20150313.ebuild,v 1.3 2015/04/14 13:15:03 ago Exp $

EAPI=5

inherit eutils

MY_P="wireless-regdb-${PV:0:4}.${PV:4:2}.${PV:6:2}"
DESCRIPTION="Binary regulatory database for CRDA"
HOMEPAGE="http://wireless.kernel.org/en/developers/Regulatory"
SRC_URI="https://www.kernel.org/pub/software/network/${PN}/${MY_P}.tar.xz"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86"
IUSE=""

S="${WORKDIR}/${MY_P}"

src_prepare() {
	epatch -p1 "${FILESDIR}/db.txt.patch"
}

src_compile() {
	einfo "Recompiling regulatory.bin from db.txt will break CRDA verification."
	emake
}

src_install() {
	# This file is not ABI-specific, and crda itself always hardcodes
	# this path.  So install into a common location for all ABIs to use.
	insinto /usr/lib/crda
	doins regulatory.bin

	insinto /etc/wireless-regdb/pubkeys
	doins *.pem

	doman regulatory.bin.5
	dodoc README db.txt
}