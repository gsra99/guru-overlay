# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit multilib

DESCRIPTION="Open Source implementation of Audio Processing Technology codec (aptX)"
HOMEPAGE="https://github.com/pali/libopenaptx"
SRC_URI="https://github.com/pali/libopenaptx/releases/download/${PV}/${P}.tar.gz"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND=""

src_install() {
	emake DESTDIR="${D}" PREFIX="${EPREFIX}"/usr LIBDIR="$(get_libdir)" install
}
