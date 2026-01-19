# Copyright 2026
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson vala xdg

DESCRIPTION="Slick-looking LightDM greeter"
HOMEPAGE="https://github.com/linuxmint/slick-greeter"
SRC_URI="https://github.com/linuxmint/slick-greeter/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

S="${WORKDIR}/slick-greeter-${PV}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
IUSE="nls"

DEPEND="
	dev-libs/glib:2
	x11-libs/cairo
	x11-libs/gdk-pixbuf
	x11-libs/gtk+:3
	x11-libs/pango
	x11-misc/lightdm[introspection]
"
RDEPEND="
	${DEPEND}
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
		-Dvala=true
		$(meson_feature nls)
	)
	meson_src_configure
}

src_install() {
	meson_src_install
}
