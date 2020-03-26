# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{4,5,6} )

inherit cmake-utils eutils gnome2-utils xdg-utils python-single-r1 toolchain-funcs git-r3

if [[ ${PV} == 9999* ]]; then
	EGIT_REPO_URI="https://git.launchpad.net/${PN}"
else
	EGIT_REPO_URI="https://git.launchpad.net/${PN}"
	EGIT_COMMIT="1%0.9.14.1+20.04.20200211-0ubuntu1"
fi

S="${WORKDIR}/${P}"
KEYWORDS="~amd64 ~x86"
DESCRIPTION="OpenGL window and compositing manager"
HOMEPAGE="http://www.compiz.org/"

LICENSE="GPL-2 LGPL-2.1 MIT"
SLOT="0.9"

IUSE="+cairo debug dbus fuse gles gnome gtk kde +svg test"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

COMMONDEPEND="
	${PYTHON_DEPS}
	!x11-wm/compiz-fusion
	!x11-libs/compiz-bcop
	!x11-libs/libcompizconfig
	!x11-libs/compizconfig-backend-gconf
	!x11-libs/compizconfig-backend-kconfig4
	!x11-plugins/compiz-plugins-main
	!x11-plugins/compiz-plugins-extra
	!x11-plugins/compiz-plugins-unsupported
	!x11-apps/ccsm
	!dev-python/compizconfig-python
	!x11-apps/fusion-icon
	dev-libs/boost
	dev-libs/glib:2
	dev-cpp/glibmm
	dev-libs/libxml2
	dev-libs/libxslt
	$(python_gen_cond_dep '
		dev-python/cython[${PYTHON_MULTI_USEDEP}]
	')
	dev-libs/protobuf
	media-libs/libpng
	x11-base/xorg-server
	x11-libs/libX11
	x11-libs/libXcomposite
	x11-libs/libXdamage
	x11-libs/libXext
	x11-libs/libXrandr
	x11-libs/libXrender
	x11-libs/libXinerama
	x11-libs/libICE
	x11-libs/libSM
	x11-libs/startup-notification
	virtual/opengl
	virtual/glu
	cairo? ( x11-libs/cairo[X] )
	fuse? ( sys-fs/fuse:= )
	gtk? (
		x11-libs/gtk+:3
		x11-libs/libwnck:3
		x11-libs/pango
		gnome? (
			gnome-base/gnome-desktop:=
			gnome-base/gconf
			x11-wm/metacity
		)
	)
	kde? ( kde-plasma/kwin )
	svg? (
		gnome-base/librsvg:2
		x11-libs/cairo
	)
	dbus? ( sys-apps/dbus )"

DEPEND="${COMMONDEPEND}
	app-admin/chrpath
	virtual/pkgconfig
	test? (
		dev-cpp/gtest
	)"

RDEPEND="${COMMONDEPEND}
	x11-apps/mesa-progs
	x11-apps/xvinfo
	x11-themes/hicolor-icon-theme"
PATCHES=(
	"${FILESDIR}/access_violation.patch"
)

pkg_pretend() {
	if [[ ${MERGE_TYPE} != binary ]]; then
		[[ $(gcc-major-version) -lt 4 ]] || \
		( [[ $(gcc-major-version) -eq 4 && $(gcc-minor-version) -lt 6 ]] ) \
		&& die "Sorry, but gcc 4.6 or higher is required."
	fi
}

pkg_setup() {
	python-single-r1_pkg_setup
}

src_prepare() {
	cmake-utils_src_prepare
	sed -i \
		-e 's|CYTHON_BIN cython3|CYTHON_BIN cython|' \
		-e "s|/lib/python|/$(get_libdir)/python|" \
		compizconfig/compizconfig-python/CMakeLists.txt || die
	eapply_user
}

src_configure() {
	use debug && CMAKE_BUILD_TYPE=Debug
	local mycmakeargs=(
		-DUSE_GLES=$(usex gles)
		-DUSE_GNOME=$(usex gnome)
		-DUSE_METACITY=$(usex gnome)
		-DUSE_GTK=$(usex gtk)
		-DCMAKE_BUILD_TYPE=Release
		-DCOMPIZ_BUILD_TESTING=$(usex test)
		-DCOMPIZ_DEFAULT_PLUGINS=composite,opengl,decor,resize,place,move,ccp
		-DCOMPIZ_DISABLE_SCHEMAS_INSTALL=On
		-DCOMPIZ_PACKAGING_ENABLED=On
		-DCOMPIZ_BUILD_WITH_RPATH=Off
		-DCOMPIZ_BUILD_TESTING=Off
		-DCOMPIZ_WERROR=Off
		-Wno-dev
	)
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	python_fix_shebang "${ED}"
	python_optimize
}

pkg_preinst() {
	use gnome && gnome2_gconf_savelist
	gnome2_icon_savelist
}

pkg_postinst() {
	use gnome && gnome2_gconf_install
	xdg_desktop_database_update
	xdg_icon_cache_update
	if use dbus; then
		ewarn "The dbus plugin is known to crash compiz in this version. Disable"
		ewarn "it if you experience crashes when plugins are enabled/disabled."
	fi
}

pkg_prerm() {
	use gnome && gnome2_gconf_uninstall
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_icon_cache_update
}
