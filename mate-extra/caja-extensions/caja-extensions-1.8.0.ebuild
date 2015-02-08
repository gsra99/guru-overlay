# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"
GCONF_DEBUG="yes"
GNOME2_LA_PUNT="yes"

inherit mate autotools

DESCRIPTION="Several Caja extensions"
HOMEPAGE="http://www.mate-desktop.org"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"

SENDTO="cdr gajim +mail pidgin upnp"
IUSE="image-converter +open-terminal share ${SENDTO}"

RDEPEND=">=x11-libs/gtk+-2.18:2
	>=dev-libs/glib-2.25.9:2
	>=mate-base/caja-1.8.0
	open-terminal? ( >=mate-base/mate-desktop-1.6.0 )
	cdr? ( >=app-cdr/brasero-2.32.1 )
	gajim? (
		net-im/gajim
		>=dev-libs/dbus-glib-0.60 )
	pidgin? ( >=dev-libs/dbus-glib-0.60 )
	upnp? ( >=net-libs/gupnp-0.13.0 )"
DEPEND="${RDEPEND}
	sys-devel/gettext
	virtual/pkgconfig
	>=dev-util/intltool-0.35
	>=mate-base/mate-common-1.2.2
	x11-libs/gksu
	!!mate-extra/mate-file-manager-open-terminal
	!!mate-extra/mate-file-manager-sendto
	!!mate-extra/mate-file-manager-image-converter
	!!mate-extra/mate-file-manager-share
	!!mate-extra/mate-file-manager-gksu"

src_prepare() {
	epatch "${FILESDIR}/${PN}-1.8.0-sendto-options.patch"
	eautoreconf
}

src_configure() {
	DOCS="AUTHORS ChangeLog NEWS README"

	if use cdr || use mail || use pidgin || use gajim || use upnp; then
		G2CONF="${G2CONF} --enable-sendto"

		local myconf
		myconf="--with-sendto-plugins=removable-devices"
		use cdr && myconf="${myconf},caja-burn"
		use mail && myconf="${myconf},emailclient"
		use pidgin && myconf="${myconf},pidgin"
		use gajim && myconf="${myconf},gajim"
		use upnp && myconf="${myconf},upnp"
	else
		G2CONF="${G2CONF} --disable-sendto"
	fi

	G2CONF="${G2CONF}
		--enable-gksu
		$(use_enable image-converter)
		$(use_enable open-terminal)
		$(use_enable share)"

	gnome2_src_configure ${myconf}
}
