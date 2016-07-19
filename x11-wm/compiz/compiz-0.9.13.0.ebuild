# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit versionator

MINOR_VERSION=$(get_version_component_range 4)
MAJOR_BRANCH=$(get_version_component_range 1-3)

if [[ ${MINOR_VERSION} == 9999 ]]; then
	EBZR_REPO_URI="http://bazaar.launchpad.net/~compiz-team/compiz/${MAJOR_BRANCH}"
	inherit bzr
	KEYWORDS=""
	SRC_URI=""
else
	KEYWORDS="~amd64 ~x86"
	SRC_URI="http://launchpad.net/${PN}/${MAJOR_BRANCH}/${PV}/+download/${P}.tar.bz2"
fi

inherit eutils cmake-utils gnome2-utils python-r1 toolchain-funcs

DESCRIPTION="OpenGL compositing window manager."
HOMEPAGE="https://launchpad.net/compiz"
LICENSE="GPL-2 LGPL-2.1 MIT"
SLOT="0.9"
IUSE="gnome +gtk3 kde gles2 test"
REQUIRED_USE="|| ( gnome gtk3 kde )"

COMMONDEPEND="
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
	dev-libs/boost:=[${PYTHON_USEDEP}]
	dev-libs/glib:2[${PYTHON_USEDEP}]
	dev-cpp/glibmm
	dev-libs/libxml2[${PYTHON_USEDEP}]
	dev-libs/libxslt[${PYTHON_USEDEP}]
	dev-python/pyrex[${PYTHON_USEDEP}]
	media-libs/libpng:0=
	>=gnome-base/librsvg-2.14.0:2
	media-libs/mesa[gallium,llvm,gles2?]
	x11-base/xorg-server[dmx]
	>=x11-libs/cairo-1.0[gles2?]
	x11-libs/libX11
	x11-libs/libXcomposite
	x11-libs/libXdamage
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXrandr
	x11-libs/libXrender
	x11-libs/libXinerama
	x11-libs/libICE
	x11-libs/libSM
	>=x11-libs/startup-notification-0.7
	x11-libs/pango
	gtk3? (
		>=x11-libs/gtk+-3.12
		>=gnome-base/gsettings-desktop-schemas-3.8
		x11-libs/libwnck:3
		gnome? (
			>=x11-wm/metacity-3.12
		)
	)
	kde? ( >=kde-base/kwin-4.11.1 )
	${PYTHON_DEPS}"

DEPEND="${COMMONDEPEND}
	sys-devel/gettext
	virtual/pkgconfig
	x11-proto/damageproto
	x11-proto/xineramaproto
	test? ( dev-cpp/gtest
		dev-cpp/gmock
		sys-apps/xorg-gtest )"

RDEPEND="${COMMONDEPEND}
	dev-libs/protobuf:=
	x11-apps/mesa-progs
	x11-apps/xvinfo"

pkg_pretend() {
	if [[ ${MERGE_TYPE} != binary ]]; then
		[[ $(gcc-major-version) -lt 4 ]] || \
				( [[ $(gcc-major-version) -eq 4 && $(gcc-minor-version) -lt 6 ]] ) \
			&& die "Sorry, but gcc 4.6 or higher is required."
	fi
}

src_unpack() {
	if [[ ${MINOR_VERSION} == 9999 ]]; then
		bzr_src_unpack
	else
		default
	fi
}

src_prepare() {
	epatch -p1 "${FILESDIR}/compiz-python2.patch"

	echo "gtk/gnome/compiz-wm.desktop.in" >> "${S}/po/POTFILES.skip"
	echo "metadata/core.xml.in" >> "${S}/po/POTFILES.skip"

	# Fix wrong path for icons
	sed -i 's:DataDir = "@prefix@/share":DataDir = "/usr/share":' compizconfig/ccsm/ccm/Constants.py.in
}

src_configure() {
	local mycmakeargs=(
		#"$(cmake-utils_use_use gnome GNOME)"
		#"$(cmake-utils_use_use gnome GSETTINGS)"
		#"$(cmake-utils_use_use gtk3 GTK)"
		#"$(cmake-utils_use_use kde KDE4)"
		#"$(cmake-utils_use test COMPIZ_BUILD_TESTING)"
		"-DCMAKE_INSTALL_PREFIX=/usr"
		"-DCOMPIZ_DEFAULT_PLUGINS=ccp"
		"-DCOMPIZ_DISABLE_SCHEMAS_INSTALL=ON"
		"-DCOMPIZ_PACKAGING_ENABLED=ON"
	)
	cmake-utils_src_configure
}

src_install() {
	pushd "${CMAKE_BUILD_DIR}"

	# Fix paths to avoid sandbox access violation
	# 'emake DESTDIR=${D} install' does not work with compiz cmake files!
	for i in `find . -type f -name "cmake_install.cmake"`;do
		sed -e "s|/usr|${D}/usr|g" -i "${i}"  || die "sed failed"
	done

	emake install
	popd
}

pkg_preinst() {
	gnome2_schemas_savelist
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_schemas_update
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_schemas_update
}
