# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit linux-info linux-mod eutils versionator git-r3

DESCRIPTION=""
HOMEPAGE=""

MY_PN="rtl8812AU"
MY_PV=$(replace_version_separator 3 '-' )
EGIT_REPO_URI="https://github.com/astsam/rtl8812au.git"
EGIT_BRANCH="v4.3.21"
EGIT_COMMIT="59f2baf8cfccf7fde5cfa9302ef1937263a8c556"
EGIT_CHECKOUT_DIR="${WORKDIR}/${MY_PN}-${MY_PV}"
S="${EGIT_CHECKOUT_DIR}"
MODULE_NAMES="8812au(net/wireless:${S}:${S})"
CONFIG_CHECK="CFG80211_WEXT"
ERROR_CFG80211_WEXT="Please build kernel with cfg80211 wireless extensions compatibility 
  Networking support --->
    Wireless --->
      cfg80211 - wireless configuration API --->
        cfg80211 wireless extensions compatibility"

LICENSE=""
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

src_unpack() {
	git-r3_src_unpack
}

src_prepare() {
	epatch "${FILESDIR}/rtl8812au-4.3.21.patch"
}

pkg_setup() {
	eselected=$(eselect kernel list | awk '/\*/ {print $2}' | awk 'gsub("linux-", "")')
	running=$(uname -r)
	if [ "$running" != "$eselected" ]; then
		die "Please ensure the eselected kernel source and running kernel are the same version, then try again."
	fi

	linux-mod_pkg_setup
	kernel_is -gt 4 8 && die "Kernels higher than 4.8 are not supported"
}

src_compile() {
	set_arch_to_kernel
	KSRC="${KV_DIR}" KVER="${KV_FULL}" emake
}

src_install() {
	linux-mod_src_install
}
