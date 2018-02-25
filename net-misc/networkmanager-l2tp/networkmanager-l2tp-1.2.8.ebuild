# Distributed under the terms of the GNU General Public License v2

EAPI="6"
GNOME_ORG_MODULE="NetworkManager-${PN##*-}"

inherit gnome2 user

MY_PN="network-manager-l2tp"

DESCRIPTION="NetworkManager L2TP - for L2TP and L2TP over IPSec VPN support."
HOMEPAGE="https://github.com/nm-l2tp/network-manager-l2tp"
SRC_URI="https://github.com/nm-l2tp/${MY_PN}/archive/${PV}.tar.gz"
RESTRICT="mirror"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gtk"

RDEPEND="
	>=net-misc/networkmanager-1.2:=
	>=dev-libs/glib-2.32.2:2
	>=dev-libs/dbus-glib-0.74
	=net-dialup/ppp-2.4.7*
	dev-libs/xml2:2
	net-dialup/xl2tpd
	net-vpn/libreswan
	gtk? (
		>=app-crypt/libsecret-0.18
		>=x11-libs/gtk+-3.4:3
	)"

DEPEND="${RDEPEND}
	sys-devel/gettext
	dev-util/intltool
	virtual/pkgconfig"

S="${WORKDIR}/${MY_PN}-${PV}"

src_configure() {
	# We cannot drop libnm-glib support yet (--without-libnm-glib)
	# because gnome-shell wasn't ported yet:
	# https://bugzilla.redhat.com/show_bug.cgi?id=1394977
	# https://bugzilla.redhat.com/show_bug.cgi?id=1398425
	gnome2_src_configure \
		--disable-more-warnings \
		--disable-static \
		$(use_with gtk gnome) \
		$(use_with gtk authdlg)
}

pkg_postinst() {
	gnome2_pkg_postinst
	enewgroup nm-l2tp
	enewuser nm-l2tp -1 -1 -1 nm-l2tp
}
