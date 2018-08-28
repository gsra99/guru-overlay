# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils git-r3

EGIT_REPO_URI="git://linuxtv.org/edid-decode.git"

DESCRIPTION="Edid decoder"
HOMEPAGE="https://cgit.freedesktop.org/xorg/app/edid-decode"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="virtual/libc"
RDEPEND="app-text/dos2unix
	app-shells/zsh"
