# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit eutils git-r3 cmake-utils

DESCRIPTION="LXQt system-tray applet for ConnMan"
HOMEPAGE="https://github.com/lxqt/lxqt-connman-applet"

EGIT_REPO_URI="https://github.com/lxqt/lxqt-connman-applet.git"
EGIT_COMMIT="940493ce509bb2784738d547cc27df677b4835a2"
EGIT_BRANCH="master"

LICENSE="LGPL"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="net-misc/connman
	lxqt-base/liblxqt
	dev-libs/libqtxdg
	dev-qt/qtdbus:5
	dev-qt/qtsvg:5
	dev-qt/qtwidgets:5"
RDEPEND="${DEPEND}"
