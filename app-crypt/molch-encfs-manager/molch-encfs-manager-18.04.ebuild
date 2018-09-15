# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils qmake-utils

MY_PN="MolchEncfsManager"

DESCRIPTION="The Molch Encfs Manager (or short MEncfsM) is an easy to use yet powerful tool to manage and mount encfs encrypted folders (stashes)."
HOMEPAGE="https://moritzmolch.com/apps/mencfsm/index.html"
SRC_URI="https://moritzmolch.com/apps/download/mencfsm/${PV}/${MY_PN}-${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	>=dev-qt/qtsvg-5.10.0
	>=dev-qt/qtdbus-5.10.0
"

RDEPEND="${DEPEND}
	>=dev-qt/qtnetwork-5.10.0
	>=sys-fs/encfs-1.9.2
"

S="${WORKDIR}/${MY_PN}-${PV}"

src_configure() {
	eqmake5
}

src_compile() {
	emake
}

src_install() {
	default
	dobin ${MY_PN}/${MY_PN}
}
