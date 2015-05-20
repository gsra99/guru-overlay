# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/libvncserver/libvncserver-0.9.10-r1.ebuild,v 1.5 2015/05/19 07:25:14 ago Exp $

EAPI="5"

inherit autotools multilib-minimal git-r3

DESCRIPTION="library for creating vnc servers"
HOMEPAGE="http://libvncserver.sourceforge.net/"
EGIT_REPO_URI="https://github.com/LibVNC/libvncserver.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="+24bpp gcrypt gnutls ipv6 +jpeg +png ssl static-libs test threads +zlib"

DEPEND="
	gcrypt? ( >=dev-libs/libgcrypt-1.5.3:0[${MULTILIB_USEDEP}] )
	gnutls? (
		>=net-libs/gnutls-2.12.23-r6[${MULTILIB_USEDEP}]
		>=dev-libs/libgcrypt-1.5.3:0[${MULTILIB_USEDEP}]
	)
	!gnutls? (
		ssl? ( >=dev-libs/openssl-1.0.1h-r2[${MULTILIB_USEDEP}] )
	)
	jpeg? ( >=virtual/jpeg-0-r2:0[${MULTILIB_USEDEP}] )
	png? ( >=media-libs/libpng-1.6.10:0[${MULTILIB_USEDEP}] )
	zlib? ( >=sys-libs/zlib-1.2.8-r1[${MULTILIB_USEDEP}] )"
RDEPEND="${DEPEND}"

DOCS=( AUTHORS ChangeLog NEWS README TODO )

src_prepare() {
	sed -i -r \
		-e "/^SUBDIRS/s:\<$(usex test 'test|' '')client_examples|examples\>::g" \
		Makefile.am || die

	eautoreconf
}

multilib_src_configure() {
	ECONF_SOURCE=${S} \
	econf \
		--disable-silent-rules \
		$(use_enable static-libs static) \
		$(use_with 24bpp) \
		$(use_with gnutls) \
		$(usex gnutls --with-gcrypt $(use_with gcrypt)) \
		$(usex gnutls --without-ssl $(use_with ssl)) \
		$(use_with ipv6) \
		$(use_with jpeg) \
		$(use_with png) \
		$(use_with threads pthread) \
		$(use_with zlib)
}

multilib_src_install_all() {
	einstalldocs
	prune_libtool_files
}
