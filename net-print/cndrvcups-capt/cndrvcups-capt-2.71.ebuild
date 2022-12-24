# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=7
inherit multilib eutils
MY_P=${P/_p/-}-1

DESCRIPTION="Canon CUPS Capt driver"
HOMEPAGE="http://www.canon.com/"
SRC_URI="http://gdlp01.c-wss.com/gds/6/0100004596/05/linux-capt-drv-v271-uken.tar.gz"

LICENSE="CANON"
SLOT="0"
KEYWORDS="~amd64 ~x86"

MY_P=${P/_p/-}-1

MY_PV="$(ver_rs 1- '')"
SOURCES_NAME="linux-capt-drv-v${MY_PV}-uken"



DEPEND=">=net-print/cups-1.1.17
		>=x11-libs/gtk+-2.4.0
		>=gnome-base/libglade-2.4.0"



#QA_TEXTRELS="${dir:1}/libcaiocaptnet.so.1.0.0"

S=${WORKDIR}/${SOURCES_NAME}/Src/${P/_p/-}-1


pkg_postinst() {

	# create fifo file for comunication with printer
	if [[ ! -d "${ROOT}"/var/ccpd ]]; then
		mkdir -p "${ROOT}"/var/ccpd
	fi

	if [ ! -e "${ROOT}"/var/ccpd/fifo0  ]; then
		mkfifo  -m 600 "${ROOT}"/var/ccpd/fifo0
	fi

	chown lp:lp "${ROOT}"/var/ccpd/fifo0 || die

	einfo "To get your printer working you need to restart cupsd"
	einfo
	einfo "/etc/init.d/cupsd restart"
	einfo
	einfo "Now you can add your printer with either the webinterface or lpadmin"
	einfo
	einfo "/usr/sbin/lpadmin -p LBP3050 -m CNCUPSLBP3050CAPTK.ppd -v ccp:/var/ccpd/fifo0 -E"
	einfo
	einfo "Replace 3050 with either on of the following printers:"
	einfo "1120 1210 2900 3000 3050 3200 3210 3300 5000 LBP5050"
	einfo "LBP5100 LBP5100 LBP6000\6018 LBP6020 LBP6200 LBP6300n"
	einfo "LBP6300 LBP6310 LBP7010C\7018C LBP7200C LBP7210C LBP9100C"
	einfo
	einfo "Now you must register the printer in ccpd, if connected with usb"
	einfo
	einfo "/usr/sbin/ccpdadmin -p LBP3050 -o /dev/usb/lp0"
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
	einfo "/etc/init.d/ccpd start"
	einfo
	einfo "For monitoring printer use Gui tool: "
	einfo
	einfo "/usr/sbin/captstatusui -p LBP3050"
	einfo
	einfo
	einfo "For more details and toubleshooting please see:"
	einfo
	einfo "https://wiki.gentoo.org/wiki/Canon_CAPT_Printer"
	einfo
	einfo
}


src_unpack() {

	if [ "${A}" != "" ]; then
		unpack ${A}
		cd "${WORKDIR}/linux-capt-drv-v271-uken/Src/"
		unpack ./cndrvcups-capt-2.71-1.tar.gz

		S=${WORKDIR}/${SOURCES_NAME}
	fi
}


src_prepare() {

    sed -i 's@#include <cups/cups.h>@#include <cups/cups.h>\n#include <cups/ppd.h>@' Src/cndrvcups-capt-2.71/statusui/src/ppapdata.c

	eapply_user

	S=${WORKDIR}/${SOURCES_NAME}/Src/cndrvcups-capt-2.71
}


src_configure() {

	for _dir in driver ppd backend pstocapt pstocapt2 pstocapt3
	do
		einfo "Configuring: "${_dir}
		cd $_dir && /usr/bin/autoreconf -fi && LDFLAGS=-L/usr/$(get_libdir) CPPFLAGS=-I/usr/include ./autogen.sh --prefix=/usr --enable-progpath=/usr/bin --disable-static --libdir=/usr/$(get_libdir)
		cd ..
	done

	einfo "Configuring: statusui"
	cd statusui && /usr/bin/autoreconf -fi && LDFLAGS=-L/usr/$(get_libdir) LIBS='-lpthread -lgdk-x11-2.0 -lgobject-2.0 -lglib-2.0 -latk-1.0 -lgdk_pixbuf-2.0' CPPFLAGS=-I/usr/include ./autogen.sh --prefix=/usr --disable-static
	cd ..

	einfo "Configuring: cngplp"
	cd cngplp/ && LDFLAGS=-L${pkgdir}/usr/$(get_libdir) /usr/bin/autoreconf -fi && LDFLAGS=-L/usr/$(get_libdir) CPPFLAGS=-I/usr/include ./autogen.sh --prefix=/usr --libdir=/usr/$(get_libdir)
	cd ..

	einfo "Configuring: cngplp/files"
	cd cngplp/files && LDFLAGS=-L/usr/$(get_libdir) /usr/bin/autoreconf -fi && LDFLAGS=-L/usr/$(get_libdir) CPPFLAGS=-I/usr/include ./autogen.sh
	cd ..

}

src_compile() {

	emake -j1

}

src_install() {


	einfo "Installing cndrvcups-capt package"
	for _dir in driver ppd backend pstocapt pstocapt2 pstocapt3 statusui cngplp
	do
		einfo "installing: $_dir"
		cd $_dir
		emake -j1 DESTDIR="${D}" install
		cd ..
	done


	dolib.so libs/libcaptfilter.so.1.0.0
	dolib.so libs/libcaiocaptnet.so.1.0.0
	dolib.so libs/libcncaptnpm.so.2.0.1
	dolib.so libs/libcnaccm.so.1.0

	dosym /usr/$(get_libdir)/libcaptfilter.so.1.0.0 /usr/$(get_libdir)/libcaptfilter.so.1
	dosym /usr/$(get_libdir)/libcaptfilter.so.1.0.0 /usr/$(get_libdir)/libcaptfilter.so
	dosym /usr/$(get_libdir)/libcaiocaptnet.so.1.0.0 /usr/$(get_libdir)/libcaiocaptnet.so.1
	dosym /usr/$(get_libdir)/libcaiocaptnet.so.1.0.0 /usr/$(get_libdir)/libcaiocaptnet.so
	dosym /usr/$(get_libdir)/libcncaptnpm.so.2.0.1 /usr/$(get_libdir)/libcncaptnpm.so.2
	dosym /usr/$(get_libdir)/libcncaptnpm.so.2.0.1 /usr/$(get_libdir)/libcncaptnpm.so
	dosym /usr/$(get_libdir)/libcnaccm.so.1.0  /usr/$(get_libdir)/libcnaccm.so.1
	dosym /usr/$(get_libdir)/libcnaccm.so.1.0  /usr/$(get_libdir)/libcnaccm.so

	dobin libs/captdrv
	dobin libs/captfilter
	dobin libs/captmon/captmon
	dobin libs/captmon2/captmon2
	dobin libs/captemon/captmon*

	dobin   libs/captemon/captmoncnab6 \
			libs/captemon/captmoncnab7 \
			libs/captemon/captmoncnab8 \
			libs/captemon/captmoncnab9 \
			libs/captemon/captmoncnaba \
			libs/captemon/captmoncnabb \
			libs/captemon/captmoncnabc \
			libs/captemon/captmoncnabd \
			libs/captemon/captmoncnabe \
			libs/captemon/captmoncnabf \
			libs/captemon/captmoncnabg \
			libs/captemon/captmoncnac5 \
			libs/captemon/captmoncnac6 \
			libs/captemon/captmoncnac8 \
			libs/captemon/captmoncnac9 \
			libs/captemon/captmoncnaca \
			libs/captemon/captmoncnacb \
			libs/captemon/captmoncnacc \
			libs/captemon/captmoncnacd \
			libs/captemon/captmonlbp3300 \
			libs/captemon/captmonlbp5000

	# Install bin
	if use amd64; then
		dobin libs64/ccpd libs64/ccpdadmin
	else
		dobin libs/ccpd libs/ccpdadmin
	fi

	# Install the data
	insinto /usr/share/ccpd
	doins libs/ccpddata/*

	insinto /usr/share/ccpd
	doins libs/captemon/*.BIN

	insinto /usr/share/captmon
	doins libs/captmon/msgtable.xml

	insinto /usr/share/captmon2
	doins libs/captmon2/msgtable2.xml

	insinto /usr/share/captemon
	doins libs/captemon/*.xml

	insinto /usr/share/caepcm
	doins data/C*

	insinto /usr/share/captfilter
	doins libs/CnA*

	# Install doc
	dodoc LICENSE* README* COPYING

	for i in statusui driver backend pstocapt{,2,3} ppd cngplp; do
		docinto ${i}
		dodoc ${i}/NEWS ${i}/README ${i}/AUTHORS ${i}/ChangeLog ${i}/LICENSE*
	done

	# fix captmon
	dodir /var/captmon
	fowners lp:lp /var/captmon
	keepdir /var/captmon

	# Install startupscripts
	newinitd ${FILESDIR}/${PN}-init.d ccpd

	insinto /etc
	doins samples/ccpd.conf

	# Install udev rules
	insinto /lib/udev/rules.d
	doins ${FILESDIR}/85-canon-capt.rules
}
