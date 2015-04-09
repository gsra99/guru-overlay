# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit linux-info linux-mod eutils versionator

DESCRIPTION=""
HOMEPAGE=""
PATCH_VERSION="7"
MY_PV1="${PV}_12175.20140902"
MY_PV2="$(get_version_component_range 1-2).2"
MY_PV3="${PN}-${MY_PV2}_11100.20140411-0.20140901"
SRC_URI="https://github.com/gsra99/${PN}/archive/v${MY_PV1}.tar.gz
	 
https://github.com/pld-linux/${PN}/archive/auto/th/${MY_PV3}.${PATCH_VERSION}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

src_unpack() {
	unpack ${A}
}

src_prepare() {
	S="${WORKDIR}/${PN}-${MY_PV1}"
	cd "${S}"

	EPATCH_SOURCE="${WORKDIR}/${PN}-auto-th-${MY_PV3}.${PATCH_VERSION}"
	EPATCH_OPTS="-p1"
#		epatch "linux-3.11.patch"
		epatch "disable-debug.patch"
		epatch "enable-cfg80211-support.patch"
#		epatch "update-cfg80211-support.patch"
		epatch "${FILESDIR}/warnings.patch"
		epatch "gcc-4.9.patch"
		epatch "${FILESDIR}/linux-3.18.patch"
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
	insinto "/lib/modules/${KV_FULL}/kernel/drivers/net/wireless/"
	doins 8812au.ko
}

