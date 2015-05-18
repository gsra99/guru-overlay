# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

inherit cmake-utils eutils versionator

MY_PN="${PN}-core"
MM_PV=$(get_version_component_range '1-2')

DESCRIPTION="Cairo-dock is a fast, responsive, Mac OS X-like dock."
HOMEPAGE="http://www.glx-dock.org"
SRC_URI="https://github.com/Cairo-Dock/${MY_PN}/archive/${PV}.tar.gz -> ${PN}-${PV}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="crypt xcomposite desktop_manager gtk3 +egl"

RDEPEND="
	dev-libs/dbus-glib
	dev-libs/glib:2
	dev-libs/libxml2:2
	gnome-base/librsvg:2
	net-misc/curl
	sys-apps/dbus
	x11-libs/cairo
	x11-libs/pango
	!gtk3? ( x11-libs/gtk+:2 )
	x11-libs/gtkglext
	x11-libs/libXrender
	gtk3? ( x11-libs/gtk+:3 )
	crypt? ( sys-libs/glibc )
	xcomposite? (
		x11-libs/libXcomposite
		x11-libs/libXinerama
		x11-libs/libXtst
	)
	media-libs/mesa[egl?]
"
DEPEND="${RDEPEND}
	dev-util/intltool
	virtual/pkgconfig
	sys-devel/gettext
"

S="${WORKDIR}/${MY_PN}-${PV}"
BUILD_DIR="${S}/build"

src_configure() {
	local mycmakeargs=(
		`use gtk3 && echo "-Dforce-gtk2=OFF" || echo "-Dforce-gtk2=ON"`
		`use desktop_manager && echo "-Denable-desktop-manager=ON" || echo "-Denable-desktop-manager=OFF"`
		`use egl && echo "-Denable-egl-support=ON" || echo "-Denable-egl-support=OFF"`
	)
	cmake-utils_src_configure .. -DCMAKE_INSTALL_PREFIX=/usr
}

pkg_postinst() {
	elog "Additional plugins are available to extend the functionality"
	elog "of Cairo-Dock. It is recommended to install at least"
	elog "x11-pluings/cairo-dock-plugins."
	elog
	elog "Cairo-Dock is an app that draws on a RGBA GLX visual."
	elog "Some users have noticed that if the dock is launched,"
	elog "severals qt4-based applications could crash, like skype or vlc."
	elog "If you have this problem, add the following line into your bashrc :"
	echo
	elog "alias vlc='export XLIB_SKIP_ARGB_VISUALS=1; vlc; unset XLIB_SKIP_ARGB_VISUALS'"
	elog "see http://www.qtforum.org/article/26669/qt4-mess-up-the-opengl-context.html for more details."
}
