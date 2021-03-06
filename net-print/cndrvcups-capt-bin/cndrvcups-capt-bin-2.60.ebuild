
EAPI="2"

DESCRIPTION="Driver for Canon printers"
HOMEPAGE="http://www.canon-europe.com/"
SRC_URI="http://gdlp01.c-wss.com/gds/6/0100004596/03/Linux_CAPT_PrinterDriver_V260_uk_EN.tar.gz"

LICENSE="Canon-EULA"
SLOT="0"
KEYWORDS="x86 amd64"
IUSE=""

RDEPEND="=net-print/cndrvcups-common-bin-${PV}
	 amd64? (
		 app-emulation/emul-linux-x86-baselibs
        	 app-emulation/emul-linux-x86-popt
         )
	 !amd64? (
		 dev-libs/popt
                 dev-libs/libxml2
	 )
	 net-print/cups
         net-libs/gnutls
         sys-libs/zlib
         x11-libs/pangox-compat"

DEPEND="app-arch/rpm2targz"

if [[ "$(uname -m)" = "x86_64" ]]; then
	S="${WORKDIR}/cndrvcups-capt-${PV}-1.x86_64"
else
	S="${WORKDIR}/cndrvcups-capt-${PV}-1.i386"
fi

src_unpack()
{
	unpack "${A}"
	if [[ "$(uname -m)" = "x86_64" ]]; then
		rpmunpack "${WORKDIR}/Linux_CAPT_PrinterDriver_V260_uk_EN/64-bit_Driver/RPM/cndrvcups-capt-${PV}-1.x86_64.rpm"
	else
		rpmunpack "${WORKDIR}/Linux_CAPT_PrinterDriver_V260_uk_EN/32-bit_Driver/RPM/cndrvcups-capt-${PV}-1.i386.rpm"
	fi
}

src_install()
{
	if [[ "$(uname -m)" = "x86_64" ]]; then
		cp -r "${S}/etc" "${D}"
		dodir /usr
		cp -r "${S}/usr/bin" "${S}/usr/lib64" "${S}/usr/sbin" "${S}/usr/share" -t "${D}/usr"
		dodir /usr/libexec/
		mv "${D}/usr/lib64"/cups "${D}/usr/libexec"
		dodir /usr/lib32
		cp -r "${S}/usr/lib/"* "${D}/usr/lib32/"
		cp -r "${S}/usr/local/bin" "${S}/usr/local/lib64" "${S}/usr/local/share" -t "${D}/usr"
	else
		cp -r "${S}/etc" "${D}"
        	dodir /usr
        	cp -r "${S}/usr/bin" "${S}/usr/lib" "${S}/usr/sbin" "${S}/usr/share" -t "${D}/usr"
        	dodir /usr/libexec/
        	mv "${D}/usr/lib"/cups "${D}/usr/libexec"
	        cp -r "${S}/usr/local/bin" "${S}/usr/local/lib" "${S}/usr/local/share" -t "${D}/usr"
	fi
}
