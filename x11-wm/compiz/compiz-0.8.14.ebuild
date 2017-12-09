# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="6"

inherit autotools eutils gnome2-utils

DESCRIPTION="OpenGL window and compositing manager"
HOMEPAGE="https://github.com/compiz-reloaded"
SRC_URI="https://github.com/compiz-reloaded/${PN}/releases/download/v${PV}/${P}.tar.xz"

LICENSE="GPL-2+ LGPL-2.1 MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+cairo compizconfig dbus fuse gsettings +gtk gtk3 inotify +svg marco mate"
REQUIRED_USE="compizconfig? ( gtk )
	gsettings? ( gtk )
	marco? ( gsettings )" #338071

COMMONDEPEND="
	>=dev-libs/glib-2
	dev-libs/libxml2
	dev-libs/libxslt
	media-libs/libpng:0=
	media-libs/mesa
	x11-base/xorg-server
	x11-libs/libX11
	x11-libs/libxcb
	x11-libs/libXcomposite
	x11-libs/libXdamage
	x11-libs/libXinerama
	x11-libs/libXrandr
	x11-libs/libICE
	x11-libs/libSM
	>=x11-libs/libXrender-0.9.3
	>=x11-libs/startup-notification-0.7
	virtual/glu
	x11-libs/pango
	cairo? ( >=x11-libs/cairo-1.4[X] )
	compizconfig? (
		>=x11-libs/libcompizconfig-0.8
		<x11-libs/libcompizconfig-0.9
	)
	dbus? (
		sys-apps/dbus
		dev-libs/dbus-glib
	)
	fuse? ( sys-fs/fuse )
	gsettings? ( >=dev-libs/glib-2.32 )
	gtk? (
		gtk3? (
			x11-libs/gtk+:3
			x11-libs/libwnck:3
		)
		!gtk3? (
			>=x11-libs/gtk+-2.22.0:2
			>=x11-libs/libwnck-2.22.0:1
		)
	)
	marco? ( x11-wm/marco )
	svg? (
		gnome-base/librsvg
		>=x11-libs/cairo-1.4[X]
	)
"

DEPEND="${COMMONDEPEND}
	virtual/pkgconfig
	x11-proto/damageproto
	x11-proto/xineramaproto
"

RDEPEND="${COMMONDEPEND}"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	local myconf=""
	if use gtk;
		then myconf=" --with-gtk=$(usex gtk3 3.0 2.0)"
	else
		myconf=" --disable-gtk"
	fi

	econf \
		--enable-fast-install \
		--disable-static \
		$(use_enable cairo annotate) \
		$(use_enable compizconfig) \
		$(use_enable dbus) \
		$(use_enable dbus dbus-glib) \
		$(use_enable fuse) \
		$(use_enable gsettings) \
		$(use_enable inotify) \
		$(use_enable svg librsvg) \
		$(use_enable marco) \
		$(use_enable mate) \
		${myconf}
}

src_install() {
	default
	prune_libtool_files --all
}

pkg_preinst() {
	use gsettings && gnome2_schemas_savelist
}

pkg_postinst() {
	use gsettings && gnome2_schemas_update
}

pkg_postrm() {
	use gsettings && gnome2_schemas_update
}
