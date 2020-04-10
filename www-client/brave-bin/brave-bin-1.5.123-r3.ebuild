# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

CHROMIUM_LANGS="am ar bg bn ca cs da de el en-GB en-US es es-419 et fa fi fil fr gu he
	hi hr hu id it ja kn ko lt lv ml mr ms nb nl pl pt-BR pt-PT ro ru sk sl sr
	sv sw ta te th tr uk vi zh-CN zh-TW"

inherit chromium-2 eutils gnome2-utils pax-utils unpacker xdg-utils

DESCRIPTION="Brave Web Browser"
HOMEPAGE="https://brave.com"

KEYWORDS="-* amd64"

MY_PN="brave-browser"

SRC_URI="https://github.com/brave/brave-browser/releases/download/v${PV}/${MY_PN}_${PV}_amd64.deb"

LICENSE="MPL-2.0"
SLOT="0"
IUSE=""

DEPEND=""
RDEPEND="
	app-accessibility/at-spi2-atk:2
	app-arch/bzip2
	app-misc/ca-certificates
	dev-libs/atk
	dev-libs/expat
	dev-libs/glib:2
	dev-libs/nspr
	>=dev-libs/nss-3.26
	media-libs/alsa-lib
	media-libs/fontconfig
	media-libs/freetype:2
	net-print/cups
	sys-apps/dbus
	sys-libs/libcap
	x11-libs/cairo
	x11-libs/gdk-pixbuf:2
	x11-libs/gtk+:3[X]
	>=x11-libs/libX11-1.5.0
	x11-libs/libXcomposite
	x11-libs/libXcursor
	x11-libs/libXdamage
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXi
	x11-libs/libXrandr
	x11-libs/libXrender
	x11-libs/libXScrnSaver
	x11-libs/libXtst
	x11-libs/libxcb
	x11-libs/pango
	x11-misc/xdg-utils
	gnome-base/gnome-keyring
"

QA_PREBUILT="*"
QA_DESKTOP_FILE="usr/share/applications/google-chrome.*\\.desktop"
S=${WORKDIR}
BRAVE_HOME="opt/brave.com/brave"

pkg_pretend() {
	# Protect against people using autounmask overzealously
	use amd64 || die "brave-browser only works on amd64"
}

src_unpack() {
	:
}

src_install() {
	dodir /
	cd "${ED}" || die
	unpacker

	rm -r etc usr/share/menu || die
	mv usr/share/doc/${MY_PN} usr/share/doc/${PF} || die
	mv usr/share/appdata usr/share/metainfo || die

#	sed -i "/Icon=brave-browser/c Icon=brave-bin" usr/share/applications/${MY_PN}.desktop || die

	gzip -d usr/share/doc/${PF}/changelog.gz || die
	gzip -d usr/share/man/man1/${MY_PN}-stable.1.gz || die
	if [[ -L usr/share/man/man1/${MY_PN}.1.gz ]]; then
		rm usr/share/man/man1/${MY_PN}.1.gz || die
		dosym ${PN}.1 usr/share/man/man1/${MY_PN}.1
	fi

	pushd "${BRAVE_HOME}/locales" > /dev/null || die
	chromium_remove_language_paks
	popd > /dev/null || die

	local size
	for size in 16 24 32 48 64 128 256 ; do
		newicon -s ${size} "${BRAVE_HOME}/product_logo_${size}.png" ${MY_PN}.png
	done

	pax-mark m "${BRAVE_HOME}/brave"
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
	xdg_desktop_database_update
	elog "If upgrading from an 0.25.x release or earlier, note that Brave has changed configuration folders."
	elog "you will have to import your browser data from Settings -> People -> Import Bookmarks and Settings"
	elog "then choose \"Brave (old)\". All your settings, bookmarks, and passwords should return."
}

pkg_postrm() {
	gnome2_icon_cache_update
	xdg_desktop_database_update
}
