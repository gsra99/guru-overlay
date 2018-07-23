# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=6

inherit meson

DESCRIPTION="Faba is a sexy and modern icon theme with Tango influences."
HOMEPAGE="http://snwh.org"
if [[ ${PV} == *9999* ]];then
	inherit git-r3
	SRC_URI=""
	EGIT_REPO_URI="https://github.com/moka-project/faba-icon-theme.git"
	KEYWORDS=""
else
	SRC_URI="https://github.com/snwh/faba-icon-theme/archive/v4.3.tar.gz -> ${P}.tar.gz"
	KEYWORDS="*"
	RESTRICT="mirror"
	S="${WORKDIR}/${PN}-4.3"
fi

LICENSE="LGPL-3.0"
SLOT="0"

IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

src_compile(){
	meson_src_compile "build" --prefix=/usr
}

src_install(){
	meson_src_install "build" install
}

pkg_postinst(){
	elog "Hi! Thanks for prefering Faba Icons."
	elog "If you want to use some other variants, such as Moka, "
	elog "please, install this theme first. Thanks."
}
