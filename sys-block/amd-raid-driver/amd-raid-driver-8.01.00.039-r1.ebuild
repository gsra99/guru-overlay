# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit linux-info linux-mod eutils git-r3

DESCRIPTION=""
HOMEPAGE=""

EGIT_REPO_URI="https://github.com/gsra99/raid_linux_driver.git"
MY_S="${P}/driver_sdk/src"
#S="${EGIT_COMMIT_DIR}/${MY_S}"
MODULE_NAMES="rcraid(drivers/scsi:${S}:${S})"

LICENSE=""
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/rcraid.patch"
	"${FILESDIR}/install.patch"
)

#src_unpack() {
#	git-r3_src_unpack
#}

pkg_setup() {
	kernel_is -gt 5 3 9 && die "Kernels higher than 5.3.9 are not supported"
	eselected="${KV_MAJOR}.${KV_MINOR}"
	get_version
	running="${KV_MAJOR}.${KV_MINOR}"
	if [ "${eselected}" != "${running}" ]; then
		die "Please ensure the eselected kernel source and running kernel are the same version, then try again." 
	fi
	linux-mod_pkg_setup
}

src_prepare() {
#	cd ../..
	default
}

src_compile() {
#	cd ${MY_S}
	set_arch_to_kernel
	KSRC="${KV_DIR}" KVER="${KV_FULL}" emake
}

src_install() {
#	cd ${MY_S}
#	insinto /lib/modules/${KV_FULL}/kernel/drivers/scsi
#	doins rcraid.ko
	linux-mod_src_install
}
