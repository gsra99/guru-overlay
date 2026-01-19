# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Copyright 2026
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson vala xdg

DESCRIPTION="Slick-looking LightDM greeter"
HOMEPAGE="https://github.com/linuxmint/slick-greeter"
SRC_URI="https://github.com/linuxmint/slick-greeter/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
IUSE="nls"

DEPEND="
	dev-libs/glib:2
	x11-misc/lightdm
	x11-libs/cairo
	x11-libs/gdk-pixbuf
	x11-libs/gtk+:3
	x11-libs/pango
"
RDEPEND="
	${DEPEND}
	x11-misc/lightdm
"
BDEPEND="
	$(vala_depend)
	dev-util/intltool
	virtual/pkgconfig
	nls? ( sys-devel/gettext )
"

src_prepare() {
	default
	vala_setup
}

src_configure() {
	local emesonargs=(
		$(meson_feature nls)
	)
	meson_src_configure
}

src_install() {
	meson_src_install
}
