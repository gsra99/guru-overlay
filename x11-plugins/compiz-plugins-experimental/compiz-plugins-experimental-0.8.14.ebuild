# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="6"

inherit autotools eutils

DESCRIPTION="Compiz Fusion Window Decorator Experimental Plugins"
HOMEPAGE="https://github.com/compiz-reloaded"
SRC_URI="https://github.com/compiz-reloaded/${PN}/releases/download/v${PV}/${P}.tar.xz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	gnome-base/librsvg
	virtual/jpeg:0
	>=x11-libs/compiz-bcop-0.7.3
	<x11-libs/compiz-bcop-0.9
	>=x11-plugins/compiz-plugins-main-0.8
	<x11-plugins/compiz-plugins-main-0.9
	>=x11-wm/compiz-0.8
	<x11-wm/compiz-0.9
"

DEPEND="${RDEPEND}
	>=dev-util/intltool-0.35
	>=sys-devel/gettext-0.15
	virtual/pkgconfig
	x11-libs/cairo
"

# Don't use deprecated glib-gettext
# see : https://bugzilla.gnome.org/show_bug.cgi?id=624186
PATCHES=( "${FILESDIR}"/${PN}-0.8.12-fix-glib-gettext-m4.patch )

src_prepare(){
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
