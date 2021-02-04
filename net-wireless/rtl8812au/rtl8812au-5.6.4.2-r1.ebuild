# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit linux-info linux-mod eutils git-r3

DESCRIPTION=""
HOMEPAGE=""

MY_PN="rtl8812AU"
EGIT_REPO_URI="https://github.com/aircrack-ng/rtl8812au.git"
EGIT_BRANCH="v${PV}"
EGIT_COMMIT="b65dcf4105641716d16f3a6c96507fdd9c1862b4"
EGIT_CHECKOUT_DIR="${WORKDIR}/${MY_PN}-${PV}"

CONFIG_CHECK="CFG80211_WEXT"
ERROR_CFG80211_WEXT="Please build kernel with cfg80211 wireless extensions compatibility 
  Networking support --->
    Wireless --->
      cfg80211 - wireless configuration API --->
        cfg80211 wireless extensions compatibility"

LICENSE=""
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

S="${EGIT_CHECKOUT_DIR}"

pkg_setup() {
	linux-info_pkg_setup
	kernel_is -ge 5 10 0 && die "Kernels 5.10.0 or higher are not supported"
	MODULE_NAMES="8812au(net/wireless:${S}:${S})"
	BUILD_TARGETS="clean all"
	BUILD_PARAMS="KVER=${KV_FULL}"
	linux-mod_pkg_setup
}

#src_compile() {
#	set_arch_to_kernel
#	KSRC="${KV_DIR}" KVER="${KV_FULL}" emake
#}

#src_install() {
#	linux-mod_src_install
#}
