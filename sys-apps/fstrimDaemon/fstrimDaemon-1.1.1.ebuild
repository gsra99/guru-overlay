# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v3
# 

EAPI="5"

inherit eutils

DESCRIPTION="Very lightweight demon executing fstrim to improve ssd drives performance"
HOMEPAGE="https://github.com/dobek/fstrimDaemon"
SRC_URI="https://github.com/dobek/${PN}/archive/v${PV}.tar.gz -> ${PF}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND=""
RDEPEND="sys-apps/util-linux"

src_prepare() {
	epatch -p1 "${FILESDIR}/${PN}-conf.d.patch"
}

src_install() {
	exeinto /usr/sbin
	newexe "${S}"/usr/sbin/${PN}.sh ${PN}
	doconfd "${S}"/etc/conf.d/${PN}
	doinitd "${S}"/etc/init.d/${PN}
	insinto /usr/lib/systemd/system
	doins "${S}"/usr/lib/systemd/system/${PN}.service
}
