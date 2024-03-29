# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_P="wireless-regdb-${PV:0:4}.${PV:4:2}.${PV:6:2}"
DESCRIPTION="Binary regulatory database for CRDA"
HOMEPAGE="https://wireless.wiki.kernel.org/en/developers/regulatory/wireless-regdb"
SRC_URI="https://www.kernel.org/pub/software/network/${PN}/${MY_P}.tar.xz"
S="${WORKDIR}/${MY_P}"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~ia64 ~mips ppc ppc64 ~riscv sparc x86"

DEPEND="dev-python/m2crypto
	app-editors/vim"

src_prepare() {
	cd ${S}
	rm sforshee.*
	eapply_user
}

src_compile() {
	default
	for cert in "${S}"/*.x509.pem ; do
	if [ -e "$cert" ]; then
	openssl x509 -in "$cert" -inform PEM &>/dev/null;
		if [ $? -eq 0 ]; then
		file=`basename "$cert"`
		inc=${file%.x509.pem}
		openssl x509 -in "$cert" -inform PEM -outform DER | xxd -i -c 8 > "${S}"/${inc}.hex
		fi
	fi
	done
}

src_install() {
	# This file is not ABI-specific, and crda itself always hardcodes
	# this path.  So install into a common location for all ABIs to use.
	insinto /usr/lib/crda
	doins regulatory.bin

	insinto /etc/wireless-regdb/pubkeys
	doins *.key.pub.pem

	insinto /etc/wireless-regdb/certs
	doins *.x509.pem

	insinto /lib/firmware/certs
	doins *.hex

	# Linux 4.15 now complains if the firmware loader
	# can't find these files #643520
	insinto /lib/firmware
	doins regulatory.db
	doins regulatory.db.p7s

	doman regulatory.bin.5
	dodoc README db.txt
}

pkg_postinst() {
	ewarn "Please run:"
	ewarn "emerge -1 net-wireless/crda"
	ewarn "As CRDA verify will be broken."
}
