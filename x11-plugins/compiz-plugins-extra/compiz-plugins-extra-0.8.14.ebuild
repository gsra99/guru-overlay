# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="6"

inherit autotools eutils

DESCRIPTION="Compiz Fusion Window Decorator Extra Plugins"
HOMEPAGE="https://github.com/compiz-reloaded"
SRC_URI="https://github.com/compiz-reloaded/${PN}/releases/download/v${PV}/${P}.tar.xz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="libnotify"

RDEPEND="
	gnome-base/librsvg
	libnotify? ( x11-libs/libnotify )
	>=x11-libs/compiz-bcop-0.7.3
	<x11-libs/compiz-bcop-0.9
	>=x11-plugins/compiz-plugins-main-0.8
	<x11-plugins/compiz-plugins-main-0.9
	>=x11-wm/compiz-0.8
	<x11-wm/compiz-0.9
	virtual/jpeg:0
"

DEPEND="${RDEPEND}
	>=dev-util/intltool-0.35
	>=sys-devel/gettext-0.15
	x11-libs/cairo
	virtual/pkgconfig
"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		--enable-fast-install \
		--disable-static
}

src_install() {
	default
	prune_libtool_files
}
