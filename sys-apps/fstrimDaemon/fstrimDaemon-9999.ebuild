# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v3
# 

EAPI="5"

inherit git-r3

DESCRIPTION="Very lightweight demon executing fstrim to improve ssd drives performance"
HOMEPAGE="https://github.com/dobek/fstrimDaemon"
EGIT_REPO_URI="https://github.com/dobek/fstrimDaemon.git"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND=""
RDEPEND="sys-apps/util-linux"

src_prepare() {
	epatch -p1 "${FILESDIR}/${PN}-conf.d.patch"
}

src_install() {
	dosbin "${S}"/usr/sbin/${PN}.sh ${PN}
	fperms 755 "${D}"/usr/sbin/${PN}
	doconfd etc/conf.d/${PN}
	doinitd etc/init.d/${PN}
	fperms 755 "${D}"/etc/init.d/${PN}
	insinto /usr/lib/systemd/system
	doins usr/lib/systemd/system/${PN}.service /usr/lib/systemd/system/${PN}.service
	fperms 755 "${D}"/usr/lib/systemd/system/${PN}.service
}
