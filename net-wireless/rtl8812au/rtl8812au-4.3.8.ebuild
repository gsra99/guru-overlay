# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit linux-info linux-mod eutils versionator

DESCRIPTION=""
HOMEPAGE=""
PATCH_VERSION="7"
MY_PV1="${PV}_12175.20140902"
MY_PV2="${PN}-$(get_version_component_range 1-2).2_11100.20140411-0.20140901"
MY_P="rtl8812AU_linux_v${MY_PV1}"
S="${WORKDIR}/${MY_P}"
MODULE_NAMES="8812au(net/wireless:${S})"
RESTRICT="mirror"
SRC_URI="http://www.comfast.cn/upload/%E8%BD%AF%E4%BB%B6%E9%A9%B1%E5%8A%A8/%E7%BD%91%E5%8D%A1%E7%B1%BB/8812AU%20912%E3%80%817500AC/linux/RTL8812AU_linux_v${MY_PV1}.zip -> ${PF}.zip
	 mirror://www.netis-systems.com/Files/others/WF2190/netis%20WF2190%20Driver%20for%20Linux.zip -> ${PF}.zip
	 https://github.com/pld-linux/${PN}/archive/auto/th/${MY_PV2}.${PATCH_VERSION}.tar.gz -> ${PN}_patches-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

src_unpack() {
	unpack ${A}
	unpack ./RTL8812AU_linux_v${MY_PV1}/driver/${MY_P}.tar.gz
}

src_prepare() {
	EPATCH_SOURCE="${WORKDIR}/${PN}-auto-th-${MY_PV2}.${PATCH_VERSION}"
	EPATCH_OPTS="-p1"
		#epatch "linux-3.11.patch"
		epatch "disable-debug.patch"
		epatch "enable-cfg80211-support.patch"
		#epatch "update-cfg80211-support.patch"
		#epatch "warnings.patch"
		#epatch "linux-3.18.patch"
		epatch "gcc-4.9.patch"
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
