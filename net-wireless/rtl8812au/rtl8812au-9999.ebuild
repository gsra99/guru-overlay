# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit git-r3 linux-info linux-mod eutils versionator

DESCRIPTION=""
HOMEPAGE=""
PATCH_VERSION="8"
MY_PV="${PN}-4.3.2_11100.20140411-0.20140901"
MODULE_NAMES="8812au(net/wireless:${S})"
S="${WORKDIR}/${P}"
EGIT_REPO_URI="https://github.com/Grawp/rtl8812au.git"
SRC_URI="https://github.com/pld-linux/${PN}/archive/auto/th/${MY_PV}.${PATCH_VERSION}.tar.gz -> ${PN}-4.3.2_patches-v${PATCH_VERSION}.tar.gz"

LICENSE=""
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

src_unpack() {
	git-r3_src_unpack
}

src_prepare() {
	cd "${S}"
	EPATCH_SOURCE="${WORKDIR}/${PN}-auto-th-${MY_PV}.${PATCH_VERSION}"
	EPATCH_OPTS="-p1"
		epatch "disable-debug.patch"
		epatch "enable-cfg80211-support.patch"
		if [[ $(gcc-major-version) -eq 4 ]] && [[ $(gcc-minor-version) -eq 9 ]]; then
			epatch "gcc-4.9.patch"
		fi
		epatch "linux-4.0.patch"
		epatch "${FILESDIR}/TRENDnet.patch"
}

pkg_setup() {
        linux-mod_pkg_setup
        kernel_is -gt 3 18 && die "kernel higher than 3.18 is not supported"
}

src_compile() {
	set_arch_to_kernel
	KSRC="${KV_DIR}" KVER="${KV_FULL}" emake
}

src_install() {
	#insinto "/lib/modules/${KV_FULL}/kernel/drivers/net/wireless/"
	#doins 8812au.ko
	linux-mod_src_install
}
