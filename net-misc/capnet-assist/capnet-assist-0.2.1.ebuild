# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
VALA_MIN_API_VERSION="0.26"

inherit cmake-utils gnome2-utils multilib vala versionator

DESCRIPTION="Assists users in connective to Captive Portals such as those found on public access points in train stations, coffee shops, universities, etc."
HOMEPAGE="https://launchpad.net/capnet-assist"
SRC_URI="https://launchpad.net/${PN}/loki/${PV}/+download/${P}.tar.xz -> ${P}.tar.xz"
RESTRICT="mirror"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	>=dev-libs/glib-2.32:2
	>=app-crypt/gcr-3.12.0[vala]
	>=net-libs/webkit-gtk-2.18.0:4
	>=x11-libs/gtk+-3.12.0:3
	>=net-misc/networkmanager-1.4.4
"
DEPEND="${RDEPEND}
	$(vala_depend)
	>=dev-libs/granite-0.3.0
	dev-util/meson
	sys-devel/gettext
	virtual/pkgconfig
"

DOCS=( AUTHORS )

src_prepare() {
	vala_src_prepare
	sed -i -e "/NAMES/s:valac:${VALAC}:" cmake/FindVala.cmake || die
	cmake-utils_src_prepare
}

src_configure() {
	cmake-utils_src_configure
}

src_install() {
	addpredict "/usr/share/glib-2.0/schemas/"
	cd "${WORKDIR}/${P}_build/"
	emake DESTDIR="${D}" install
	#cmake-utils_src_install
}

pkg_preinst() {
	gnome2_schemas_savelist
}

pkg_postinst() {
	gnome2_schemas_update
}

pkg_postrm() {
	gnome2_schemas_update
}
