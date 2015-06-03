# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit linux-info linux-mod eutils versionator

DESCRIPTION=""
HOMEPAGE=""
PATCH_VERSION="8"
MY_PV1="${PV}_11100.20140411"
MY_PV2="${PN}-$(get_version_component_range 1-2).2_11100.20140411-0.20140901"
MY_P="rtl8812AU_linux_v${MY_PV1}"
S="${WORKDIR}/${MY_P}"
MODULE_NAMES="8812au(net/wireless:${S})"
RESTRICT="mirror"
SRC_URI="ftp://ftp2.dlink.com/PRODUCTS/DWA-182/REVC/DWA-182_REVC_DRIVER_${PV}_LINUX.ZIP -> ${PF}.zip
	 https://github.com/pld-linux/${PN}/archive/auto/th/${MY_PV2}.${PATCH_VERSION}.tar.gz -> ${PN}-4.3.2_patches-v${PATCH_VERSION}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
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
		epatch "linux-3.11.patch"
		epatch "disable-debug.patch"
		epatch "enable-cfg80211-support.patch"
		epatch "update-cfg80211-support.patch"
		epatch "warnings.patch"
		if [[ $(gcc-major-version) -eq 4 ]] && [[ $(gcc-minor-version) -eq 9 ]]; then
                        epatch "gcc-4.9.patch"
                fi
		epatch "linux-3.18.patch"
		epatch "linux-4.0.patch"
		epatch "${FILESDIR}/TRENDnet.patch"
}

pkg_setup() {
	eselected=$(eselect kernel list | awk '/\*/ {print $2}' | awk 'gsub("linux-", "")')
	running=$(uname -r)
	if [ "$running" != "$eselected" ]; then
		die "Please ensure the eselected kernel source and running kernel are the same version, then try again."
	fi

        linux-mod_pkg_setup
        kernel_is -gt 4 0 && die "Kernel higher than 4.0 is not supported."
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
