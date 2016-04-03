# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit linux-info linux-mod eutils versionator

DESCRIPTION=""
HOMEPAGE=""
MY_PN="rtl8812AU"
MY_PV=$(replace_version_separator 3 '-' )
S="${WORKDIR}/${MY_PN}-${MY_PN}-${MY_PV}"
SRC_URI="https://github.com/diederikdehaas/${MY_PN}/archive/${MY_PN}-${MY_PV}.tar.gz"
MODULE_NAMES="8812au(net/wireless:${S}:${S})"

LICENSE=""
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

src_unpack() {
	unpack ${A}
}

pkg_setup() {
	eselected=$(eselect kernel list | awk '/\*/ {print $2}' | awk 'gsub("linux-", "")')
	running=$(uname -r)
	if [ "$running" != "$eselected" ]; then
		die "Please ensure the eselected kernel source and running kernel are the same version, then try again."
	fi

	linux_config_exists
	if false; then
		die "please configure and build running kernel first"
	else linux_chkconfig_present CFG80211_WEXT
		if false; then
			die "please build kernel with CFG80211_WEXT"
		else linux-mod_pkg_setup
        		kernel_is -gt 4 2 && die "kernel higher than 4.2 is not supported"
		fi
	fi
}

src_compile() {
	set_arch_to_kernel
	KSRC="${KV_DIR}" KVER="${KV_FULL}" emake
}

src_install() {
	linux-mod_src_install
}
