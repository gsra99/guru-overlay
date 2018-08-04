# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header:

EAPI="6"

inherit git-r3 gnome2-utils

DESCRIPTION="Mint-X GTK themes"
HOMEPAGE="https://github.com/linuxmint/mint-x-icons"
EGIT_REPO_URI="https://github.com/linuxmint/mint-x-icons.git"
EGIT_BRANCH="master"
EGIT_COMMIT="4859fc8675f893096f8c9bfdb568eadf740c630b"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
	x11-themes/faenza-icon-theme"

RESTRICT="binchecks strip"

src_install() {
	insinto /usr/share/icons
	doins -r usr/share/icons/Mint-X{,-Dark} || die
	dodoc debian/changelog debian/copyright
}

pkg_preinst() { gnome2_icon_savelist; }
pkg_postinst() { gnome2_icon_cache_update; }
pkg_postrm() { gnome2_icon_cache_update; }
