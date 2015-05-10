# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit linux-info linux-mod eutils versionator git-r3

DESCRIPTION=""
HOMEPAGE=""
#PATCH_VERSION="8"
MY_PV1="${PV}_12175.20140902"
#MY_PV2="${PN}-$(get_version_component_range 1-2).2_11100.20140411-0.20140901"
MY_P="rtl8812AU_linux_v${MY_PV1}"
S="${WORKDIR}/${MY_P}"
MODULE_NAMES="8812au(net/wireless:${S})"
RESTRICT="mirror"
SRC_URI="http://www.netis-systems.com/Files/others/WF2190/netis%20WF2190%20Driver%20for%20Linux.zip -> ${PF}.zip"
EGIT_REPO="https://github.com/gsra99/rtl8812au_patches.git"
MIRROR_URI="http://www.comfast.cn/upload/%E8%BD%AF%E4%BB%B6%E9%A9%B1%E5%8A%A8/%E7%BD%91%E5%8D%A1%E7%B1%BB/8812AU%20912%E3%80%817500AC/linux/RTL8812AU_linux_v${MY_PV1}.zip -> ${PF}.zip
	    http://www.netis-systems.com/Files/others/WF2190/netis%20WF2190%20Driver%20for%20Linux.zip -> ${PF}.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

src_unpack() {
	unpack ${A}
	unpack ./RTL8812AU_linux_v${MY_PV1}/driver/${MY_P}.tar.gz
	git-r3_src_unpack
}

src_prepare() {
	EPATCH_SOURCE="${WORKDIR}/rtl8812au_patches"
	EPATCH_OPTS="-p1"
		epatch "disable-debug.patch"
		epatch "enable-cfg80211-support.patch"
		epatch "warnings.patch"
		if [[ $(gcc-major-version) -eq 4 ]] && [[ $(gcc-minor-version) -eq 9 ]]; then
			epatch "gcc-4.9.patch"
		fi
		epatch "linux-3.18.patch"
		epatch "linux-4.0.patch"
		epatch "reproducible-builds.patch"
		epatch "${FILESDIR}/TRENDnet.patch"
		#epatch "${FILESDIR}/increase_rtlwifi_tx_power.patch"
}

pkg_setup() {
        linux-mod_pkg_setup
        kernel_is -gt 4 0 && die "kernel higher than 4.0 is not supported"
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
