# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit git-r3 linux-info linux-mod subversion eutils

DESCRIPTION=""
HOMEPAGE=""
EGIT_REPO_URI="https://github.com/austinmarton/rtl8812au_linux.git"
PATCHES_URI="https://github.com/pld-linux/rtl8812au/archive/auto/th/rtl8812au-4.3.2_11100.20140411-0.20140901.7.tar.gz"
#PATCHES="${FILESDIR}/rtl8812au.patch"

LICENSE=""
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

src_unpack() {
	git_src_unpack
	S="${WORKDIR}/patches"
	ESVN_REPO_URI="${PATCHES_URI}"
	subversion_src_unpack
}

src_prepare() {
	S="${WORKDIR}/${P}"
	cd "${S}"
	EPATCH_OPTS="-p1" epatch "${WORKDIR}/patches"/*.patch
}

pkg_setup() {
        linux-mod_pkg_setup
        kernel_is -gt 3 13 && die "kernel higher than 3.13 is not supported"
}

src_compile() {
	set_arch_to_kernel
	KSRC="${KV_DIR}" KVER="${KV_FULL}" emake
}

src_install() {
	insinto "/lib/modules/${KV_FULL}/kernel/drivers/net/wireless/"
	doins 8812au.ko
	#emake MODDESTDIR="${ED}/lib/modules/${KV_FULL}/kernel/drivers/net/wireless/" install
}

