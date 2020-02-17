# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Broadcom Bluetooth firmware for Linux kernel"
HOMEPAGE="Broadcom Bluetooth firmware for Linux kernel"
SRC_URI="https://github.com/winterheart/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

src_prepare() {
	default
}

src_install() {
	default
	mkdir -p "${S}/lib/firmware/brcm"
	mv "${S}/brcm" "${S}/lib/firmware/brcm"
	doins -r "${S}/lib"
	for file in $(ls ${S}/lib/firmware/brcm/brcm); do
		dosym "brcm/${file}" "/lib/firmware/brcm/BCM-${file#*-}"
	done
}

