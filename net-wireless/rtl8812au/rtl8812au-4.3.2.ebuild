# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit linux-info linux-mod eutils versionator

DESCRIPTION=""
HOMEPAGE=""
PATCH_VERSION="7"
MY_PV1="${PV}_11100.20140411"
MY_PV2="${PN}-$(get_version_component_range 1-2).2_11100.20140411-0.20140901"
MY_P="${PN}-${MY_PV1}"
S="${WORKDIR}/${MY_P}"
MODULE_NAMES="8812au(net/wireless:${S})"
RESTRICT="mirror"
SRC_URI="ftp://ftp2.dlink.com/PRODUCTS/DWA-182/REVC/DWA-182_REVC_DRIVER_4.3.2_LINUX.ZIP -> ${P}.zip
	 https://github.com/pld-linux/${PN}/archive/auto/th/${MY_PV2}.${PATCH_VERSION}.tar.gz -> ${P}-patches.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

src_unpack() {
	unpack ${A}
	unpack ./RTL8812AU_linux_v${MY_PV1}/driver/rtl8812AU_linux_v${MY_PV1}.tar.gz
}

src_prepare() {
	EPATCH_SOURCE="${WORKDIR}/${PN}-auto-th-${MY_PV2}.${PATCH_VERSION}"
	EPATCH_OPTS="-p1"
		epatch "linux-3.11.patch"
		epatch "disable-debug.patch"
		epatch "enable-cfg80211-support.patch"
		epatch "update-cfg80211-support.patch"
		epatch "warnings.patch"
		epatch "gcc-4.9.patch"
		epatch "linux-3.18.patch"
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
