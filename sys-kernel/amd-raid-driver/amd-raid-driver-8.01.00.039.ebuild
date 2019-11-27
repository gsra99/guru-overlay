# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit linux-info linux-mod eutils git-r3

DESCRIPTION=""
HOMEPAGE=""

MY_PN="raid_linux_driver"
EGIT_REPO_URI="https://github.com/gsra99/raid_linux_driver.git"
EGIT_CHECKOUT_DIR="${WORKDIR}/${MY_PN}"
S="${EGIT_CHECKOUT_DIR}/driver_sdk/src"
MODULE_NAMES="rcraid(drivers/scsi:${S}:${S})"

LICENSE=""
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

PATCHES=(
#	"${FILESDIR}/rcraid.patch"
	"${FILESDIR}/install.patch"
)

src_unpack() {
	git-r3_src_unpack
}

pkg_setup() {
	kernel_is -gt 5 3 9 && die "Kernels higher than 5.3.9 are not supported"
	eselected="${KV_MAJOR}.${KV_MINOR}"
	get_running_version
	running="${KV_MAJOR}.${KV_MINOR}"
	if [ "${eselected}" != "${running}" ]; then
		die "Please ensure the eselected kernel source and running kernel are the same version, then try again." 
	fi
	linux-mod_pkg_setup
}

src_compile() {
	set_arch_to_kernel
	KSRC="${KV_DIR}" KVER="${KV_FULL}" emake
}

src_install() {
	linux-mod_src_install
}
