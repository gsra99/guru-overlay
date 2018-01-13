# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

VALA_MIN_API_VERSION="0.28"

inherit gnome2-utils meson vala

DESCRIPTION="Flagship desktop of Solus, designed with the modern user in mind"
HOMEPAGE="https://solus-project.com/budgie/
	https://github.com/budgie-desktop/budgie-desktop"
SRC_URI="https://github.com/${PN}/${PN}/releases/download/v${PV}/${P}.tar.xz"
IUSE="bluetooth +introspection +polkit"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
COMMON_DEPEND=">=app-i18n/ibus-1.5.11[vala]
	>=dev-libs/glib-2.46.0:2
	dev-libs/gjs
	>=dev-libs/libpeas-1.8.0:0
	>=gnome-base/gnome-desktop-3.18.0:3
	>=gnome-base/gnome-menus-3.10.1
	>=media-sound/pulseaudio-2.0
	>=sys-apps/accountsservice-0.6
	>=sys-power/upower-0.9.20
	>=x11-libs/gtk+-3.16.0:3
	>=x11-libs/libwnck-3.14.0:3
	>=x11-wm/mutter-3.18.0:=
	bluetooth? ( >=net-wireless/gnome-bluetooth-3.18.0:2 )
	polkit? ( >=sys-auth/polkit-0.110 )"
DEPEND="${COMMON_DEPEND}
	$(vala_depend)
	dev-lang/sassc
	>=dev-util/intltool-0.50.0
	dev-util/meson
	dev-util/ninja
	introspection? ( >=dev-libs/gobject-introspection-1.44.0 )"
RDEPEND="${COMMON_DEPEND}
	>=gnome-base/gnome-session-3.18.0
	x11-themes/gnome-themes-standard"

RESTRICT="mirror"

src_prepare() {
	default

	# Meson bug workaround
	cp -R src/gvc subprojects/gvc/ || die
	sed -i -e 's:../../src/::g' \
		subprojects/gvc/meson.build || die

	vala_src_prepare
}

src_configure() {
	local emesonargs=(
		-Dwith-bluetooth=$(usex bluetooth true false)
		-Dwith-introspection=$(usex introspection true false)
		-Dwith-polkit=$(usex polkit true false)
		-Dwith-stateless=true
	)
	meson_src_configure
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
	gnome2_icon_cache_update
}
