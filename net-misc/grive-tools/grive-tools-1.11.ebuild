# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="Grive Tools - Ubuntu Google Drive desktop integration made easy."
HOMEPAGE="https://launchpad.net/~thefanclub/+archive/ubuntu/grive-tools"
SRC_URI="https://launchpad.net/~thefanclub/+archive/ubuntu/grive-tools/+files/${PN}_${PV}.tar.gz"

LICENSE="GPL"
SLOT="0"
KEYWORDS="x86 amd64"
IUSE=""

DEPEND=">=net-misc/grive-0.3.0_pre20130503
        >=gnome-extra/zenity-3.8.0-r2"
RDEPEND=""

src_unpack()
{
   unpack ${PN}_${PV}.tar.gz
}
src_install()
{
   dodir /opt
   cp -r "${WORKDIR}/${PN}"/opt "${D}"

   dodir /usr
   cp -r "${WORKDIR}/${PN}"/usr "${D}"
}
