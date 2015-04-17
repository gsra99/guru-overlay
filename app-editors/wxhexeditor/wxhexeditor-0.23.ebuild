# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-editors/wxhexeditor/wxhexeditor-0.22.ebuild,v 1.2 2014/08/10 17:42:44 slyfox Exp $

EAPI="5"

WX_GTK_VER="2.8"

inherit eutils toolchain-funcs wxwidgets

MY_PN="wxHexEditor"

DESCRIPTION="A cross-platform hex editor designed specially for large files"
HOMEPAGE="http://wxhexeditor.sourceforge.net/"
SRC_URI="http://sourceforge.net/projects/${PN}/files/${MY_PN}/v${PV}%20Beta/${MY_PN}-v${PV}-src.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	app-crypt/mhash
	dev-libs/udis86
	x11-libs/wxGTK:2.8[X]"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_PN}"

pkg_pretend() {
	tc-has-openmp \
		|| die "${PN} uses OpenMP libraries. Please use an OpenMP-capable compiler."
}

src_compile () {
	emake OPTFLAGS="-fopenmp"
}

#src_prepare() {
	# parts sent upstream : https://sourceforge.net/p/wxhexeditor/patches/8/
	#epatch "${FILESDIR}"/${P}-makefile.patch
#}
