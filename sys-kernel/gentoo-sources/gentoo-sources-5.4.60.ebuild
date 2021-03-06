# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"
ETYPE="sources"
K_WANT_GENPATCHES="base extras experimental"
K_GENPATCHES_VER="61"

inherit kernel-2
detect_version
detect_arch

KEYWORDS="~alpha amd64 ~arm arm64 ~hppa ~ia64 ~mips ~ppc ppc64 ~s390 ~sparc x86"
HOMEPAGE="https://dev.gentoo.org/~mpagano/genpatches"
IUSE="experimental"

DESCRIPTION="Full sources including the Gentoo patchset for the ${KV_MAJOR}.${KV_MINOR} kernel tree"
SRC_URI="${KERNEL_URI} ${GENPATCHES_URI} ${ARCH_URI}"

UNIPATCH_LIST="${FILESDIR}/10001-snd-usb-audio.patch"
UNIPATCH_STRICTORDER="${FILESDIR}/10001-snd-usb-audio.patch"

src_prepare() {
	kernel-2_src_prepare
	unipatch
}

pkg_postinst() {
	kernel-2_pkg_postinst
	einfo "For more info on this patchset, and how to report problems, see:"
	einfo "${HOMEPAGE}"
}

pkg_postrm() {
	kernel-2_pkg_postrm
}
