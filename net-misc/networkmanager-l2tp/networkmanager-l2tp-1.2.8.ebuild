# Distributed under the terms of the GNU General Public License v2

EAPI="5"

inherit eutils gnome.org autotools

MY_PN="network-manager-l2tp"

DESCRIPTION="NetworkManager L2TP - for L2TP and L2TP over IPSec VPN support."
HOMEPAGE="https://github.com/nm-l2tp/network-manager-l2tp"
SRC_URI="https://github.com/nm-l2tp/${MY_PN}/archive/${PV}.tar.gz"
RESTRICT="primaryuri"
#EGIT_REPO_URI="git://github.com/nm-l2tp/network-manager-l2tp.git"
#EGIT_COMMIT="b8f85b97ef3db430e41c1b973cf0aed563aa82bf"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gnome"

RDEPEND="
	>=net-misc/networkmanager-0.8.1
	>=dev-libs/dbus-glib-0.74
	=net-dialup/ppp-2.4.7*
	net-dialup/xl2tpd
	net-vpn/libreswan
	gnome? (
		x11-libs/gtk+:3
		gnome-base/gconf:2
		gnome-base/gnome-keyring
		gnome-base/libglade:2.0
	)"

DEPEND="${RDEPEND}
	sys-devel/gettext
	dev-util/intltool
	virtual/pkgconfig"

S="${WORKDIR}/${MY_PN}-${PV}"

src_prepare() {
	mkdir -p m4
	intltoolize --copy --force --automake
	eautoreconf
}

src_configure() {
	ECONF="--with-pppd-plugin-dir=/usr/lib/pppd/2.4.7
		$(use_with gnome)"

	econf ${ECONF}
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
}
