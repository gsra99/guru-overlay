# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools git-r3 gnome2-utils

DESCRIPTION="Vertex icon theme"
HOMEPAGE="https://github.com/0i0/arc-icon-theme"
EGIT_REPO_URI="https://github.com/0i0/arc-icon-theme.git"
EGIT_BRANCH="maste"
EGIT_COMMIT="e019b0b0c3311b492a092827910e00632a6026d9"

LICENSE="GPL-3"
SLOT="0"
IUSE=""
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~arm-linux ~x86-linux ~sparc-solaris ~x64-solaris ~x86-solaris"

RDEPEND="
	x11-themes/adwaita-icon-theme
"
DEPEND=""

# This ebuild does not install any binaries
RESTRICT="binchecks strip"

src_prepare() {
	default
	eautoreconf
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
