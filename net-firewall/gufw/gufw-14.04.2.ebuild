# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit versionator distutils-r1

MY_PV_12=$(get_version_component_range 1-2)
DESCRIPTION="A program used to manage a netfilter firewall"
HOMEPAGE="https://launchpad.net/gui-ufw"
SRC_URI="http://launchpad.net/gui-ufw/gufw-${MY_PV_12}/${MY_PV_12}/+download/gui-ufw-${PV}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND=">=net-firewall/ufw-0.34_pre805-r1
	dev-python/netifaces
	>=net-libs/webkit-gtk-2.2.5:3[introspection]
	x11-libs/gtk+:3[introspection]
	>=x11-themes/gnome-icon-theme-symbolic-3.6.2
	sys-auth/polkit
	dev-python/python-distutils-extra
	dev-lang/python:2.7[ipv6]"
RDEPEND="$DEPEND"

S="${WORKDIR}/gui-ufw-${PV}"

python_install() {
        distutils-r1_python_install --prefix=/usr
}
