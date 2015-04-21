# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-kernel/gentoo-sources/gentoo-sources-3.18.11.ebuild,v 1.2 2015/04/06 14:09:24 mpagano Exp $

EAPI="5"
ETYPE="sources"
K_WANT_GENPATCHES="base extras experimental"
K_GENPATCHES_VER="13"
K_DEBLOB_AVAILABLE="0"
inherit kernel-2
detect_version
detect_arch

KEYWORDS="alpha amd64 ~arm ~arm64 hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc x86"
HOMEPAGE="http://dev.gentoo.org/~mpagano/genpatches"
IUSE="deblob experimental"

DESCRIPTION="Full sources including the Gentoo patchset for the ${KV_MAJOR}.${KV_MINOR} kernel tree"
SRC_URI="${KERNEL_URI} ${GENPATCHES_URI} ${ARCH_URI}"

src_prepare() {
	EPATCH_SOURCE="${FILESDIR}"
	EPATCH_OPTS="-p1"
		epatch "302-ath9k-restart-only-triggering-DFS-detector-line-r44655.patch"
		epatch "303-ath9k-add-DFS-support-for-extension-channel-r44655.patch"
		epatch "304-ath9k-allow-40MHz-radar-detection-width-r44655.patch"
		epatch "402-ath_regd_optional-r43210.patch"
		epatch "403-world_regd_fixup-r42952.patch"
		epatch "405-ath_regd_us-r42952.patch"
		epatch "406-ath_relax_default_regd-r45252.patch"
		epatch "500-ath9k_eeprom_debugfs-r43208.patch"
		epatch "522-mac80211_configure_antenna_gain-r43342.patch"
}

pkg_postinst() {
	kernel-2_pkg_postinst
	einfo "For more info on this patchset, and how to report problems, see:"
	einfo "${HOMEPAGE}"
}

pkg_postrm() {
	kernel-2_pkg_postrm
}
