# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit git-r3 git-2 linux-info linux-mod eutils

DESCRIPTION=""
HOMEPAGE=""
EGIT_REPO_URI="https://github.com/austinmarton/rtl8812au_linux.git"
SRC_URI="https://github.com/pld-linux/rtl8812au/archive/auto/th/rtl8812au-4.3.2_11100.20140411-0.20140901.7.tar.gz"
#PATCHES="${FILESDIR}/rtl8812au.patch"

LICENSE=""
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

src_unpack() {
	git-2_src_unpack
}

src_prepare() {
	S="${WORKDIR}/${P}"
	cd "${S}"
	PATCHES="${WORKDIR}/rtl8812au-auto-th-rtl8812au-4.3.2_11100.20140411-0.20140901.7"
	EPATCH_OPTS="-p1"
		epatch "${PATCHES}/linux-3.11.patch"
		epatch "${PATCHES}/disable-debug.patch"
		epatch "${PATCHES}/enable-cfg80211-support.patch"
		epatch "${PATCHES}/update-cfg80211-support.patch"
		epatch "${PATCHES}/warnings.patch"
		epatch "${PATCHES}/gcc-4.9.patch"
		epatch "${PATCHES}/linux-3.18.patch"
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

