# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit linux-info multilib

DESCRIPTION="Samsung Unified Linux Driver"
HOMEPAGE="https://www.bchemnet.com/suldr/index.html"
SRC_URI="https://www.bchemnet.com/suldr/driver/UnifiedLinuxDriver-4.00.36.tar.gz -> ${P}.tar.gz"

LICENSE="samsung"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="cups scanner network qt4"
RESTRICT="mirror strip"
REQUIRED_USE="network? ( cups )
	qt4? ( cups )"

DEPEND="!net-print/samsung-unified-driver:2"
# libstdc++.so.5 is needed only by libscmcss.so which apparently is not required
# for normal printing/scanning operations and ldd doesn't show any binary that needs it.
# So, skip virtual/libstdc++ as we skip libscmcss.so installation below.
# If you have any problems regarding libstdc++.so.5 add virtual/libstdc++ to RDEPEND.
#RDEPEND="virtual/libstdc++
RDEPEND="virtual/libusb:0
	cups? (
		net-print/cups
		!net-print/splix
	)
	qt4? (
		dev-qt/qtcore:4[qt3support]
		media-libs/tiff
	)
	scanner? (
		media-gfx/sane-backends
		dev-libs/libxml2:2
	)"

S=${WORKDIR}/cdroot/Linux

pkg_setup() {
	if use kernel_linux; then
		linux-info_pkg_setup
		if ! linux_config_exists; then
			ewarn "Can't check the linux kernel configuration."
			ewarn "You might have some incompatible options enabled."
		else
			if use scanner; then
				if ! linux_chkconfig_present USB_PRINTER; then
					ewarn "You've enabled scanner support then you should also enable the USB_PRINTER"
					ewarn "support in your kernel config."
					ewarn "Please enable it:"
					ewarn "    CONFIG_USB_PRINTER=y"
					ewarn "in /usr/src/linux/.config or"
					ewarn "    Device Drivers --->"
					ewarn "        USB support  --->"
					ewarn "            [*] USB Printer support"
					ewarn "Scanning WILL NOT work without loaded usblp module or via libusb."
				fi
			fi
		fi
	fi
}

src_unpack() {
	tar xozf "${DISTDIR}/${A}"
}

src_prepare() {
	find . -type d -exec chmod 755 '{}' \;
	find . -type f -exec chmod 644 '{}' \;

	chmod 755 ./i386/at_opt/bin/netdiscovery
	chmod 755 ./i386/at_root/opt/smfp-common/lib/*
	chmod 755 ./i386/at_root/usr/lib/libmfp.so.*
	chmod 755 ./i386/at_root/usr/lib/cups/filter/*
	chmod 755 ./i386/at_root/usr/lib/cups/backend/mfp
	chmod 755 ./i386/at_root/usr/lib/sane/*
	chmod 755 ./i386/at_root/usr/sbin/*
	chmod 755 ./i386/qt4/at_opt/bin/*
	chmod 755 ./i386/qt4/at_opt/lib/*

	chmod 755 ./x86_64/at_opt/bin/netdiscovery
	chmod 755 ./x86_64/at_root/opt/smfp-common/lib/*
	chmod 755 ./x86_64/at_root/usr/lib64/libmfp.so.*
	chmod 755 ./x86_64/at_root/usr/lib64/cups/filter/*
	chmod 755 ./x86_64/at_root/usr/lib64/cups/backend/mfp
	chmod 755 ./x86_64/at_root/usr/lib64/sane/*
	chmod 755 ./x86_64/at_root/usr/sbin/*
	chmod 755 ./x86_64/qt4/at_opt/bin/*
	chmod 755 ./x86_64/qt4/at_opt/lib/*
}

src_install() {
	SOPT="/opt/Samsung/mfp"
	if [ "${ABI}" == "amd64" ]; then
		SARCH="x86_64"
		SLIBDIR="lib64"
	else
		SARCH="i386"
		SLIBDIR="lib"
	fi

	# Common lib needed both for printing and scanning
	dolib ${SARCH}/at_root/usr/${SLIBDIR}/libmfp.so.*
	dosym libmfp.so.1.0.1 /usr/$(get_libdir)/libmfp.so

	# Printing support
	if use cups; then
		# Gentoo has only net-analyzer/net-snmp to provide libnetsnmp.so on x86/amd64
		# and recent (5.7.2) versions of this package install libnetsnmp.so.30.
		# Creating symlink of the form libnetsnmp.so.10 -> libnetsnmp.so.30
		# doesn't help as blobs segfault then.
		# So, if user somehow has old enough version of libnetsnmp.so.10
		# we will try to use it, otherwise we install lib shipped with Samsung driver.
		if [ ! -e "/usr/$(get_libdir)/libnetsnmp.so.10*" ]; then
			dolib ${SARCH}/at_root/opt/smfp-common/lib/libnetsnmp.so.*
			dosym libnetsnmp.so.10.0.2 /usr/$(get_libdir)/libnetsnmp.so.10
		else
			einfo "libnetsnmp.so.10 already exists in /usr/$(get_libdir)"
			einfo "This system-wide version will be used."
		fi

		insinto /etc/cups
		doins noarch/at_root/etc/cups/*

		exeinto /usr/libexec/cups/filter
		doexe ${SARCH}/at_root/usr/${SLIBDIR}/cups/filter/ps*
		doexe ${SARCH}/at_root/usr/${SLIBDIR}/cups/filter/raster*
		# line below installs the only binary under cups USE that requires libnetsnmp.so.10
		doexe ${SARCH}/at_root/usr/${SLIBDIR}/cups/filter/smfp*
		# libscmssc.so is not installed by default as ldd doesn't show that
		# any binary needs it. If you experience any problems related to this
		# library, uncomment the line below.
		#doexe ${SARCH}/at_root/usr/${SLIBDIR}/cups/filter/libscmssc.so

		exeinto /usr/libexec/cups/backend
		doexe ${SARCH}/at_root/usr/${SLIBDIR}/cups/backend/*

		dodir   /usr/share/cups/model/samsung
		insinto /usr/share/cups/model/samsung
		doins noarch/at_opt/share/ppd/*
		gzip "${D}"/usr/share/cups/model/samsung/*.ppd || die

		dodir   /usr/share/cups/model/samsung/cms
		insinto /usr/share/cups/model/samsung/cms
		doins noarch/at_opt/share/ppd/cms/*
	fi

	# Scanning support
	if use scanner; then
		insinto /etc/sane.d
		doins noarch/at_root/etc/sane.d/smfp.conf

		exeinto /usr/$(get_libdir)/sane/
		doexe ${SARCH}/at_root/usr/${SLIBDIR}/sane/*

		dosym libsane-smfp.so.1.0.1 /usr/$(get_libdir)/sane/libsane-smfp.so.1
		dosym libsane-smfp.so.1.0.1 /usr/$(get_libdir)/sane/libsane-smfp.so
	fi

	# Network tool
	if use network; then
		exeinto ${SOPT}/libexec
		doexe ${SARCH}/at_root/usr/sbin/smfpd
		for i in ${SARCH}/at_root/usr/sbin/*; do
			make_wrapper \
				$(basename ${i}) \
				${SOPT}/libexec/$(basename ${i}) \
				${SOPT}/libexec \
				${SOPT}/lib \
				${SOPT}/bin
		done

		exeinto ${SOPT}/libexec
		doexe ${SARCH}/at_opt/bin/netdiscovery
		for i in ${SARCH}/at_opt/bin/*; do
			make_wrapper \
				$(basename ${i}) \
				${SOPT}/libexec/$(basename ${i}) \
				${SOPT}/libexec \
				${SOPT}/lib \
				${SOPT}/bin
		done
	fi

	# GUI tools
	if use qt4; then
		if [ ! -e "/usr/$(get_libdir)/libtiff.so.3" ]; then
			ewarn "User is not forced to install media-libs/tiff:3 because"
			ewarn "Samsung's software also works with latter versions of tiff."
			ewarn "Instead, the symlink libtiff.so.3 will be created in /usr/$(get_libdir)"
			ewarn "If you have any issues regarding libtiff.so"
			ewarn "version mismatch, emerge media-libs/tiff:3."
			dosym libtiff.so /usr/$(get_libdir)/libtiff.so.3
		fi

		insinto ${SOPT}/share
		doins OEM.ini
		doins noarch/at_opt/share/VERSION*

		cp -r noarch/at_opt/share/help \
			noarch/at_opt/share/images \
			noarch/at_opt/share/utils  \
			noarch/qt4/at_opt/share/tr \
			noarch/qt4/at_opt/share/ui "${D}/${SOPT}/share"

		exeinto ${SOPT}/lib
		doexe ${SARCH}/qt4/at_opt/lib/*

		# We do not install supplied Qt4 libs and use system-wide versions instead.
		# If you want the opposite uncomment the line below
		#doexe ${SARCH}/qt4/at_root/opt/smfp-common/lib/*

		exeinto ${SOPT}/libexec
		for i in $(ls ${SARCH}/qt4/at_opt/bin/*.app); do
			newexe ${i} $(basename ${i%.app})
		done
		for i in $(ls ${SARCH}/qt4/at_opt/bin/*.app); do
			make_wrapper \
				$(basename ${i%.app}) \
				${SOPT}/libexec/$(basename ${i%.app}) \
				${SOPT}/libexec \
				${SOPT}/lib \
				${SOPT}/bin
		done
	fi
}

pkg_postinst() {
	if use scanner; then
		elog "You need to manually add smfp to /etc/sane.d/dll.conf:"
		elog "# echo smfp >> /etc/sane.d/dll.conf"
	fi
}
