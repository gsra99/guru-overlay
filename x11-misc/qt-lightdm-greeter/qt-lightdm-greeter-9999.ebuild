# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit git-r3 cmake-utils

DESCRIPTION="qt-lightdm-greeter is a simple frontend for the lightdm displaymanager, written in c++ and qt5."
HOMEPAGE="https://github.com/surlykke/qt-lightdm-greeter"
EGIT_URI="https://github.com/surlykke/qt-lightdm-greeter.git"
EGIT_BRANCH="master"

LICENSE=""
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="x11-misc/lightdm[qt5]"
RDEPEND="${DEPEND}"

