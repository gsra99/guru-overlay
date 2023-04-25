# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit linux-info linux-mod readme.gentoo-r1 toolchain-funcs unpacker

NV_KERNEL_MAX="5.15"
NV_URI="https://download.nvidia.com/XFree86/"

DESCRIPTION="NVIDIA Accelerated Graphic Driver - kernel module"
HOMEPAGE="https://www.nvidia.com/download/index.aspx"
SRC_URI="
	amd64? ( ${NV_URI}Linux-x86_64/${PV}/NVIDIA-Linux-x86_64-${PV}.run )
	x86? ( ${NV_URI}Linux-x86/${PV}/NVIDIA-Linux-x86-${PV}.run )
"

LICENSE="NVIDIA-r2"
SLOT="0/${PV%%.*}"
KEYWORDS="-* amd64 x86"

DEPEND="acct-group/video"
RDEPEND="
	${DEPEND}
	!<x11-drivers/nvidia-drivers-340.108-r100
"

S="${WORKDIR}"

# Patches taken from Ubuntu, Debian, AUR:
#   https://github.com/tseliot/nvidia-graphics-drivers/tree/340/debian/dkms_nvidia/patches
#   https://salsa.debian.org/nvidia-team/nvidia-graphics-drivers/-/tree/340xx/master/debian/module/debian/patches
#   https://aur.archlinux.org/packages/nvidia-340xx/
PATCHES=(
#	"${FILESDIR}/use-kmem_cache_create_usercopy-on-4.16.patch"
#	"${FILESDIR}/buildfix_kernel_5.7.patch"
#	"${FILESDIR}/buildfix_kernel_5.7_fix_old.patch"
#	"${FILESDIR}/buildfix_kernel_5.8.patch"
#	"${FILESDIR}/buildfix_kernel_5.9.patch"
#	"${FILESDIR}/buildfix_kernel_5.10.patch"
#	"${FILESDIR}/buildfix_kernel_5.11.patch"
#	"${FILESDIR}/buildfix_kernel_5.14.patch"
#	"${FILESDIR}/buildfix_kernel_5.15.patch"
	"${FILESDIR}/0001-kernel-5.7.patch"
	"${FILESDIR}/0002-kernel-5.8.patch"
	"${FILESDIR}/0003-kernel-5.9.patch"
	"${FILESDIR}/0004-kernel-5.10.patch"
	"${FILESDIR}/0005-kernel-5.11.patch"
	"${FILESDIR}/0006-kernel-5.14.patch"
	"${FILESDIR}/0007-kernel-5.15.patch"
	"${FILESDIR}/0008-kernel-5.16.patch"
	"${FILESDIR}/0009-kernel-5.17.patch"
	"${FILESDIR}/0010-kernel-5.18.patch"
	"${FILESDIR}/0011-kernel-6.0.patch"
	"${FILESDIR}/0012-kernel-6.2.patch"
)

pkg_setup() {
	# FIXME: kernel config checks are probably wrong
	local CONFIG_CHECK="!DEBUG_MUTEXES ~!LOCKDEP ~MTRR ~SYSVIPC ~ZONE_DMA"
	use x86 && CONFIG_CHECK+=" ~HIGHMEM"

	BUILD_PARAMS='NV_VERBOSE=1 IGNORE_CC_MISMATCH=yes SYSSRC="${KV_DIR}" SYSOUT="${KV_OUT_DIR}"'
	use amd64 && BUILD_PARAMS+=' ARCH=x86_64'
	use x86 && BUILD_PARAMS+=' ARCH=i386'
	BUILD_TARGETS="module"
	MODULE_NAMES="nvidia(video:kernel)"

	linux-mod_pkg_setup

	if [[ ${MERGE_TYPE} != binary ]] && kernel_is -gt ${NV_KERNEL_MAX/./ }; then
		ewarn "Only kernels up to ${NV_KERNEL_MAX} have been tested so far, newer kernels may"
		ewarn "or may not work."
		ewarn "You are free to apply custom patches via /etc/portage/patches to"
		ewarn "provide whatever support you feel is appropriate."
		ewarn
	fi
}

src_install() {
	linux-mod_src_install

	insinto /etc/modprobe.d
	newins "${FILESDIR}"/nvidia.modprobe nvidia.conf

	# create README.gentoo
	local DISABLE_AUTOFORMATTING="yes"
	local DOC_CONTENTS=\
"Trusted users should be in the 'video' group to use NVIDIA devices.
You can add yourself by using: gpasswd -a my-user video

See '${EPREFIX}/etc/modprobe.d/nvidia.conf' for modules options.

For general information on using nvidia-drivers, please see:
https://wiki.gentoo.org/wiki/NVIDIA/nvidia-drivers"
	readme.gentoo_create_doc

	einstalldocs
}

pkg_preinst() {
	linux-mod_pkg_preinst

	# set video group id based on live system (bug #491414)
	local g=$(getent group video | cut -d: -f3)
	[[ ${g} ]] || die "Failed to determine video group id"
	sed -i "s/@VIDEOGID@/${g}/" "${ED}"/etc/modprobe.d/nvidia.conf || die
}

pkg_postinst() {
	linux-mod_pkg_postinst

	readme.gentoo_print_elog
}
