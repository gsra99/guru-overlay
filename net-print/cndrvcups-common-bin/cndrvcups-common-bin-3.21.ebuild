
EAPI="7"

DESCRIPTION="Common files for Canon printers"
HOMEPAGE="http://www.canon-europe.com/"
SRC_URI="http://gdlp01.c-wss.com/gds/6/0100004596/05/linux-capt-drv-v271-uken.tar.gz"

LICENSE="Canon-EULA"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

RDEPEND=""

DEPEND="app-arch/rpm2targz"

src_unpack() {
	unpack ${A}
	if [[ "$(uname -m)" = "x86_64" ]]; then
		S="${WORKDIR}/cndrvcups-common-${PV}-1.x86_64"
		rpmunpack "${WORKDIR}/linux-capt-drv-v271-uken/64-bit_Driver/RPM/cndrvcups-common-${PV}-1.x86_64.rpm"
	else
		S="${WORKDIR}/cndrvcups-common-${PV}-1.i386"
		rpmunpack "${WORKDIR}/linux-capt-drv-v271-uken/32-bit_Driver/RPM/cndrvcups-common-${PV}-1.i386.rpm"
	fi
}

src_install() {
	if [[ "$(uname -m)" = "x86_64" ]]; then
		cp -r "${S}/etc" "${D}"
		dodir /usr
		cp -r "${S}/usr/bin" "${S}/usr/include" "${S}/usr/lib64" "${S}/usr/share" -t "${D}/usr"
		dodir /usr/lib32
		cp -r "${S}/usr/lib/"* "${D}/usr/lib32/"
		cp -r "${S}/usr/local/bin" "${S}/usr/local/share" -t "${D}/usr"
	else
		cp -r "${S}/etc" "${D}"
		dodir /usr
		cp -r "${S}/usr/bin" "${S}/usr/include" "${S}/usr/lib" "${S}/usr/share" -t "${D}/usr"
		cp -r "${S}/usr/local/bin" "${S}/usr/local/share" -t "${D}/usr"
	fi
}
