# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/x11vnc/x11vnc-0.9.13_p20150111.ebuild,v 1.6 2015/05/19 07:25:10 ago Exp $

EAPI=5

inherit autotools eutils git-r3

DESCRIPTION="A VNC server for real X displays"
HOMEPAGE="http://www.karlrunge.com/x11vnc/"
EGIT_REPO_URI="https://github.com/LibVNC/x11vnc.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="avahi crypt fbcon ssl xinerama"

RDEPEND="
	x11-libs/libX11
	x11-libs/libXdamage
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXrandr
	>=x11-libs/libXtst-1.1.0
	avahi? ( >=net-dns/avahi-0.6.4 )
	ssl? ( dev-libs/openssl:= )
	>=net-libs/libvncserver-0.9.8
	xinerama? ( x11-libs/libXinerama )"
DEPEND="${RDEPEND}
	x11-libs/libXt
	x11-proto/inputproto
	x11-proto/trapproto
	x11-proto/recordproto
	x11-proto/xproto
	x11-proto/xextproto
	xinerama? ( x11-proto/xineramaproto )"

DOCS=(ChangeLog README)

src_prepare() {
	eautoreconf
}

src_configure() {
	# --without-v4l because of missing video4linux 2.x support wrt #389079
	econf \
		$(use_with avahi) \
		$(use_with crypt) \
		$(use_with fbcon fbdev) \
		$(use_with ssl) \
		$(use_with ssl crypto) \
		--without-v4l \
		$(use_with xinerama)
}

src_install() {
	default
	newconfd "${FILESDIR}/x11vnc-conf" x11vnc
	newinitd "${FILESDIR}/x11vnc-init" x11vnc
}
