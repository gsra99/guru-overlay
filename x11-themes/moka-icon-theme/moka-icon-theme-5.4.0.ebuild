# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=6

inherit eutils autotools meson

DESCRIPTION="Moka is a stylized Linux desktop icon set, and the titular icon theme of the Moka Project. They are designed to be clear, simple and consistent."
HOMEPAGE="http://snwh.org"
if [[ ${PV} == *9999* ]];then
	inherit git-r3
	SRC_URI=""
	EGIT_REPO_URI="https://github.com/moka-project/moka-icon-theme.git"
	KEYWORDS=""
else
	SRC_URI="https://github.com/moka-project/moka-icon-theme/archive/v${PV}/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="*"
	RESTRICT="mirror"
fi

LICENSE="LGPL-3.0"
SLOT="0"
IUSE=""

src_compile(){
	meson_src_compile "build" --prefix=/usr
}

src_install(){
	meson_src_install "build" install
}
