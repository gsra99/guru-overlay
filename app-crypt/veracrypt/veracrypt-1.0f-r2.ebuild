# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-crypt/truecrypt/truecrypt-7.1a.ebuild,v 1.7 2013/12/08 19:57:54 alonbl Exp $

EAPI="4"

inherit flag-o-matic linux-info multilib toolchain-funcs wxwidgets eutils pax-utils

DESCRIPTION="Free open-source disk encryption software"
HOMEPAGE="http://veracrypt.codeplex.com/"
SRC_URI="http://sourceforge.net/projects/veracrypt/files/VeraCrypt%20${PV}-2/${PN}_${PV}-2_Source.tar.bz2/download -> ${PF}.tar.bz2"

LICENSE="truecrypt-3.0"
SLOT="0"
KEYWORDS="-* ~amd64 ~ppc ~x86"
IUSE="X"
RESTRICT="mirror bindist"

RDEPEND="app-arch/makeself
	dev-lang/nasm
	sys-fs/fuse
	x11-libs/wxGTK:3.0[X?]
	app-admin/sudo"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${P}/src"

#See bug 241650.

pkg_setup() {
	local CONFIG_CHECK="~BLK_DEV_DM ~DM_CRYPT ~FUSE_FS ~CRYPTO ~CRYPTO_XTS"
	linux-info_pkg_setup

	local WX_GTK_VER="3.0"
	if use X; then
		need-wxwidgets unicode
	else
		need-wxwidgets base-unicode
	fi
}

src_compile() {
	local EXTRA

	use X || EXTRA+=" NOGUI=1"

	emake ${EXTRA}
}

src_install() {
	dobin Main/veracrypt
	dodoc Readme.txt "Release/Setup Files/VeraCrypt User Guide.pdf"
	exeinto "/$(get_libdir)/rcscripts/addons"
	newexe "${FILESDIR}/${PN}-stop.sh" "${PN}-stop.sh"

	newinitd "${FILESDIR}/${PN}.init" ${PN}

	if use X; then
		newicon Resources/Icons/VeraCrypt-48x48.xpm VeraCrypt-16x16.xpm
		make_desktop_entry ${PN} "VeraCrypt" ${PN} "System"
	fi

	pax-mark -m "${D}/usr/bin/veracrypt"
}

pkg_postinst() {
	elog "There is now an init script for VeraCrypt for Baselayout-2."
	elog "If you are a baselayout-2 user and you would like the VeraCrypt"
	elog "mappings removed on shutdown in order to prevent other file systems"
	elog "from unmounting then run:"
	elog "rc-update add veracrypt boot"
	elog

	#ewarn "If you're getting errors about DISPLAY while using the terminal"
	#ewarn "it's a known upstream bug. To use VeraCrypt from the terminal"
	#ewarn "all that's necessary is to run: unset DISPLAY"
	#ewarn "This will make the display unaccessable from that terminal "
	#ewarn "but at least you will be able to access your volumes."
	#ewarn

	ewarn "VeraCrypt has a very restrictive license. Please be explicitly aware"
	ewarn "of the limitations on redistribution of binaries or modified source."
}
