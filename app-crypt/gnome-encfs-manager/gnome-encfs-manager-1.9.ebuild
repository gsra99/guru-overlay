# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools gnome2 vala

MY_PV=$(ver_cut 1-2)
DESCRIPTION="The Gnome Encfs Manager (or short GEncfsM) is an easy to use manager and mounter for encfs stashes"
HOMEPAGE="https://moritzmolch.com/apps/gencfsm/"
SRC_URI="https://launchpad.net/gencfsm/trunk/${MY_PV}/+download/${PN}_${PV}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+appindicator"

DEPEND="
	>=x11-libs/gtk+-3.22.19:3
	>=dev-libs/glib-2.50.3-r1:2
	>=gnome-base/gnome-keyring-3.20.0
	>=dev-libs/libgee-0.20.0:0.8
	>=x11-libs/libSM-1.2.2-r1
	appindicator? ( >=dev-libs/libappindicator-12.10.0-r301:3[introspection] )
	>=dev-util/intltool-0.51.0-r2
"

RDEPEND="${DEPEND}
	>=sys-fs/encfs-1.9.2
"

src_prepare() {
	# use version information from debian/changelog
	VERSION=$(head -n 1 debian/changelog | cut -d '(' -f 2 | cut -d ')' -f 1)
	sed -e "s/%VERSION%/$VERSION/" "configure.ac.in" > "configure.ac"
	eautoreconf
	gnome2_src_prepare
}

src_configure() {
	vala_src_prepare

	OPTIONS=(
		--prefix=/usr
	)

	use appindicator || OPTIONS+=(
				--disable-appindicator
				)

	gnome2_src_configure ${OPTIONS}
}
