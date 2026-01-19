# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

VALA_MIN_API_VERSION="0.20"

inherit autotools gnome2-utils vala

MY_PN="${PN#lightdm-}"
DESCRIPTION="A slick-looking LightDM greeter"
HOMEPAGE="https://github.com/linuxmint/slick-greeter"
SRC_URI="https://github.com/linuxmint/${MY_PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3.0"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="systemd"

# Interactive testsuite.
RESTRICT="test"

COMMON_DEPEND="
	|| (
		media-libs/libcanberra-gtk3
		>=media-libs/libcanberra-0.10[gtk3(-)]
	)
	>=sys-apps/dbus-1[X]
	>=x11-libs/gtk+-3.22:3
	>=x11-misc/lightdm-1.32.0[vala,X]
	>=x11-libs/pixman-0.46.4
	>=app-accessibility/at-spi2-core-2.56.5
	systemd? ( x11-misc/lightdm[systemd] )
"

RDEPEND="${COMMON_DEPEND}
	systemd? ( sys-apps/systemd )
"

BDEPEND="${COMMON_DEPEND}
"

src_configure() {
	mate_src_configure \
		--enable-compile-warnings=minimum \
		$(use_enable test tests)
}

src_test() {
	unset DBUS_SESSION_BUS_ADDRESS

	dbus-launch Xemake check || die "Test phase failed"
}
