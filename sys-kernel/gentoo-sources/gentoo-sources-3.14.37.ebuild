# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-kernel/gentoo-sources/gentoo-sources-3.14.37.ebuild,v 1.2 2015/04/06 14:09:24 mpagano Exp $

EAPI="5"
ETYPE="sources"
K_WANT_GENPATCHES="base extras experimental"
K_GENPATCHES_VER="42"
K_DEBLOB_AVAILABLE="0"
inherit kernel-2
detect_version
detect_arch

KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ~mips ~ppc ~ppc64 ~s390 ~sh sparc x86"
HOMEPAGE="http://dev.gentoo.org/~mpagano/genpatches"
IUSE="deblob experimental"

DESCRIPTION="Full sources including the Gentoo patchset for the ${KV_MAJOR}.${KV_MINOR} kernel tree"
SRC_URI="${KERNEL_URI} ${GENPATCHES_URI} ${ARCH_URI}"

src_prepare () {
	EPATCH_SOURCE="${FILESDIR}"
	EPATCH_OPTS="-p1"
	#epatch "303-ath9k-add-DFS-support-for-extension-channel.patch"
	epatch "304-ath9k-allow-40MHz-radar-detection-width.patch"
	epatch "ath9k_11n_disable.patch"
	epatch "402-ath_regd_optional.patch"
	epatch "403-world_regd_fixup.patch"
	#epatch "increase_ath_tx_power.patch"
	epatch "405-ath_regd_us.patch"
	#epatch "406-ath_relax_default_regd.patch"
	epatch "522-mac80211_configure_antenna_gain.patch"
	epatch "ath9k_initialize_txchainmask_before_testing_channel_txpower_values.patch"
	#epatch "ath9k_hw_remove_the_txpower_index_offset.patch"
	epatch "ath9k_hw_fix_calculated_runtime_txpower_limit.patch"
	epatch "ath9k_hw_do_not_limit_initial_txpower_to_20dbm.patch"
}

pkg_postinst() {
	kernel-2_pkg_postinst
	einfo "For more info on this patchset, and how to report problems, see:"
	einfo "${HOMEPAGE}"
}

pkg_postrm() {
	kernel-2_pkg_postrm
}
