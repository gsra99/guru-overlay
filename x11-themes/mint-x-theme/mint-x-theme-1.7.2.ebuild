# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header:

EAPI="6"

inherit git-r3

DESCRIPTION="Mint-X GTK themes"
HOMEPAGE="https://github.com/linuxmint/mint-themes"
EGIT_REPO_URI="https://github.com/linuxmint/mint-themes.git"
EGIT_BRANCH="master"
EGIT_COMMIT="f69a611c6b8c5b11edf3203906a6f829d564932d"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="x11-themes/gtk-engines-murrine
		 x11-themes/mint-x-icons"

DEPEND="${RDEPEND}
	dev-ruby/sass"

RESTRICT=""

#S=${WORKDIR}

src_install() {
	insinto /usr/share/themes
	doins -r usr/share/themes/'Linux Mint'
	doins -r usr/share/themes/Mint-X{,-*}/
	dodoc debian/changelog debian/copyright
}
