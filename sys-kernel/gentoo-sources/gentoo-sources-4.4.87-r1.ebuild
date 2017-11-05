# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"
ETYPE="sources"
K_WANT_GENPATCHES="base extras experimental"
K_GENPATCHES_VER="91"

inherit kernel-2
detect_version
detect_arch

KEYWORDS="alpha amd64 ~arm ~arm64 hppa ia64 ~mips ppc ppc64 ~s390 ~sh sparc x86"
HOMEPAGE="https://dev.gentoo.org/~mpagano/genpatches"
IUSE="experimental"

DESCRIPTION="Full sources including the Gentoo patchset for the ${KV_MAJOR}.${KV_MINOR} kernel tree"
SRC_URI="${KERNEL_URI} ${GENPATCHES_URI} ${ARCH_URI}"

src_prepare() {
	EPATCH_SOURCE="${FILESDIR}"
	EPATCH_OPTS="-p1"
		epatch "402-ath_regd_optional-r47771-fixed.patch"
		epatch "403-world_regd_fixup-r42952.patch"
		epatch "405-ath_regd_us-r42952.patch"
		epatch "406-ath_relax_default_regd-r45710-fixed.patch"
		epatch "410-ath9k_allow_adhoc_and_ap-r46198.patch"
}

pkg_postinst() {
	kernel-2_pkg_postinst
	einfo "For more info on this patchset, and how to report problems, see:"
	einfo "${HOMEPAGE}"
}

pkg_postrm() {
	kernel-2_pkg_postrm
}
