# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit eutils linux-info linux-mod

DESCRIPTION="Broadcom's IEEE 802.11a/b/g/n hybrid Linux device driver"
HOMEPAGE="https://www.broadcom.com/support/802.11"
SRC_URI="https://launchpad.net/ubuntu/+archive/primary/+sourcefiles/bcmwl/6.30.223.271+bdcom-0ubuntu7/bcmwl_6.30.223.271+bdcom.orig.tar.gz"

LICENSE="Broadcom"
KEYWORDS="-* ~amd64"

RESTRICT="mirror"

DEPEND="virtual/linux-sources"
RDEPEND=""

S="${WORKDIR}"

pkg_pretend() {
	ewarn
	ewarn "If you are stuck using this unmaintained driver (likely in a MacBook),"
	ewarn "you may be interested to know that a newer compatible wireless card"
	ewarn "is supported by the in-tree brcmfmac driver. It has a model number "
	ewarn "BCM943602CS and is for sale on the second hand market for less than "
	ewarn "20 USD."
	ewarn
	ewarn "See https://wikidevi.com/wiki/Broadcom_Wireless_Adapters and"
	ewarn "    https://wikidevi.com/wiki/Broadcom_BCM943602CS"
	ewarn "for more information."
	ewarn
}

pkg_setup() {
	linux-info_pkg_setup

	# bug #300570
	# NOTE<lxnay>: module builds correctly anyway with b43 and SSB enabled
	# make checks non-fatal. The correct fix is blackisting ssb and, perhaps
	# b43 via udev rules. Moreover, previous fix broke binpkgs support.
	CONFIG_CHECK="~!B43 ~!BCMA ~!SSB ~!X86_INTEL_LPSS"
	CONFIG_CHECK2="LIB80211 ~!MAC80211 ~LIB80211_CRYPT_TKIP"
	ERROR_B43="B43: If you insist on building this, you must blacklist it!"
	ERROR_BCMA="BCMA: If you insist on building this, you must blacklist it!"
	ERROR_SSB="SSB: If you insist on building this, you must blacklist it!"
	ERROR_LIB80211="LIB80211: Please enable it. If you can't find it: enabling the driver for \"Intel PRO/Wireless 2100\" or \"Intel PRO/Wireless 2200BG\" (IPW2100 or IPW2200) should suffice."
	ERROR_MAC80211="MAC80211: If you insist on building this, you must blacklist it!"
	ERROR_PREEMPT_RCU="PREEMPT_RCU: Please do not set the Preemption Model to \"Preemptible Kernel\"; choose something else."
	ERROR_LIB80211_CRYPT_TKIP="LIB80211_CRYPT_TKIP: You will need this for WPA."
	ERROR_X86_INTEL_LPSS="X86_INTEL_LPSS: Please disable it. The module does not work with it enabled."
	if kernel_is ge 3 8 8; then
		CONFIG_CHECK="${CONFIG_CHECK} ${CONFIG_CHECK2} CFG80211 ~!PREEMPT_RCU ~!PREEMPT"
	elif kernel_is ge 2 6 32; then
		CONFIG_CHECK="${CONFIG_CHECK} ${CONFIG_CHECK2} CFG80211"
	elif kernel_is ge 2 6 31; then
		CONFIG_CHECK="${CONFIG_CHECK} ${CONFIG_CHECK2} WIRELESS_EXT ~!MAC80211"
	elif kernel_is ge 2 6 29; then
		CONFIG_CHECK="${CONFIG_CHECK} ${CONFIG_CHECK2} WIRELESS_EXT COMPAT_NET_DEV_OPS"
	else
		CONFIG_CHECK="${CONFIG_CHECK} IEEE80211 IEEE80211_CRYPT_TKIP"
	fi

	kernel_is -ge 5 7 0 && die "Kernels 5.7.0 or higher are not supported"
	MODULE_NAMES="wl(net/wireless)"
	MODULESD_WL_ALIASES=("wlan0 wl")
	BUILD_PARAMS="-C ${KV_DIR} M=${S}"
	BUILD_TARGETS="wl.ko"

	linux-mod_pkg_setup
}

src_install() {
	linux-mod_src_install

	dodoc "${DISTDIR}/README-${P}.txt"
}
