# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MATE2_LA_PUNT="yes"

inherit mate git-r3

if [[ ${PV} != 9999 ]]; then
	KEYWORDS="~amd64 ~arm ~arm64 ~x86"
	SRC_URI=""
	EGIT_REPO_URI="https://github.com/mate-desktop/marco.git"
	EGIT_BRANCH="1.24"
	EGIT_COMMIT="634057c2feed37d466d0740df32ff38fb2f5cfe1"
fi

DESCRIPTION="MATE default window manager"
LICENSE="FDL-1.2+ GPL-2+ LGPL-2+ MIT"
SLOT="0/2"

IUSE="startup-notification test xinerama"
RESTRICT="!test? ( test )"

COMMON_DEPEND="
	dev-libs/atk
	>=dev-libs/glib-2.58:2
	>=gnome-base/libgtop-2:2=
	media-libs/libcanberra[gtk3]
	x11-libs/cairo
	>=x11-libs/pango-1.2[X]
	x11-libs/gdk-pixbuf:2
	>=x11-libs/gtk+-3.22:3
	x11-libs/libICE
	x11-libs/libSM
	x11-libs/libX11
	>=x11-libs/libXcomposite-0.3
	x11-libs/libXcursor
	x11-libs/libXdamage
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXpresent
	x11-libs/libXrandr
	x11-libs/libXrender
	>=x11-libs/startup-notification-0.7
	xinerama? ( x11-libs/libXinerama )
	!!x11-wm/mate-window-manager
"

RDEPEND="${COMMON_DEPEND}
	gnome-extra/zenity
	>=mate-base/mate-desktop-1.20.0
	virtual/libintl
"

DEPEND="${COMMON_DEPEND}
	app-text/yelp-tools
	>=sys-devel/gettext-0.19.8
	>=sys-devel/libtool-2.0.0
	virtual/pkgconfig
	x11-base/xorg-proto
	test? ( app-text/docbook-xml-dtd:4.5 )
	xinerama? ( x11-base/xorg-proto )
"

src_prepare() {
	force_autoreconf="true"
	mate_src_prepare
}

src_configure() {
	mate_src_configure \
		--enable-compositor \
		--enable-render \
		--enable-shape \
		--enable-sm \
		--enable-xsync \
		$(use_enable startup-notification) \
		$(use_enable xinerama)
}

src_install() {
	mate_src_install
	dodoc doc/*.txt
}
