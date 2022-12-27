
EAPI="7"

inherit multilib-minimal

DESCRIPTION="Driver for Canon printers"
HOMEPAGE="http://www.canon-europe.com/"
SRC_URI="http://gdlp01.c-wss.com/gds/6/0100004596/05/linux-capt-drv-v271-uken.tar.gz"

LICENSE="Canon-EULA"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="systemd"

RDEPEND="=net-print/cndrvcups-common-bin-3.21
	dev-libs/popt[${MULTILIB_USEDEP}]
        dev-libs/libxml2[${MULTILIB_USEDEP}]
	net-print/cups
        net-libs/gnutls
        sys-libs/zlib
        x11-libs/pangox-compat"

DEPEND="app-arch/rpm2targz"

src_unpack() {
	unpack "${A}"
	if [[ "$(uname -m)" = "x86_64" ]]; then
		S="${WORKDIR}/cndrvcups-capt-${PV}-1.x86_64"
		rpmunpack "${WORKDIR}/linux-capt-drv-v271-uken/64-bit_Driver/RPM/cndrvcups-capt-${PV}-1.x86_64.rpm"
	else
		S="${WORKDIR}/cndrvcups-capt-${PV}-1.i386"
		rpmunpack "${WORKDIR}/linux-capt-drv-v271-uken/32-bit_Driver/RPM/cndrvcups-capt-${PV}-1.i386.rpm"
	fi
}

src_install() {
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

	# Install startupscripts and udev rules
	if ! use systemd ; then
		newinitd "${FILESDIR}"/cndrvcups-capt-init.d ccpd
		insinto /lib/udev/rules.d
		doins "${FILESDIR}"/85-canon-capt-openrc.rules
	else
		insinto /lib/systemd/system
		doins "${FILESDIR}"/ccpd.service
		insinto /lib/udev/rules.d
		doins "${FILESDIR}"/85-canon-capt-systemd.rules
	fi
}

pkg_postinst() {
	einfo "To get your printer working you need to restart cupsd"
	einfo
	einfo "/etc/init.d/cupsd restart or systemctl restart cups"
	einfo
	einfo "Now you can add your printer with either the webinterface or lpadmin"
	einfo
	einfo "lpadmin -p LBP6200d -m CNCUPSLBP6200CAPTK.ppd -v ccp://localhost:59687 -E"
	einfo
	einfo "Replace 6200 with either on of the following printers:"
	einfo "1120 1210 2900 3000 3050 3200 3210 3300 5000 LBP5050"
	einfo "LBP5100 LBP5100 LBP6000\6018 LBP6020 LBP6200 LBP6300n"
	einfo "LBP6300 LBP6310 LBP7010C\7018C LBP7200C LBP7210C LBP9100C"
	einfo
	einfo "Now you must register the printer in ccpd, if connected with usb"
	einfo
	einfo "ccpdadmin -p LBP6200d -o /dev/usb/lp0"
	einfo
	einfo
	einfo "If you plan to use device /dev/usb/lp0 You will need to un-blacklist module usblp"
	einfo "this is best done by emergeing net-print/cups with USE='-usb' "
	einfo
	einfo "Notice that you can't use LPT port with this driver."
	einfo "If you have a network connection to your printer use -o net:<IP OF PRINTER>"
	einfo "instead of -o /dev/usb/lp0"
	einfo
	einfo "Now you can go ahead and start the ccpd daemon"
	einfo
	einfo "/etc/init.d/ccpd start or systemctl start ccpd"
	einfo
	einfo "For monitoring printer use Gui tool: "
	einfo
	einfo "captstatusui -p LBP6200"
	einfo
	einfo
	einfo "For more details and toubleshooting please see:"
	einfo
	einfo "https://wiki.gentoo.org/wiki/Canon_CAPT_Printer"
	einfo
	einfo
}
