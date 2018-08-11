# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=6

inherit linux-info multilib

DESCRIPTION="Samsung Unified Linux Driver"
HOMEPAGE="https://www.bchemnet.com/suldr/index.html"
SRC_URI="https://www.bchemnet.com/suldr/driver/UnifiedLinuxDriver-1.00.36.tar.gz -> ${P}.tar.gz"

LICENSE="samsung"
SLOT="2"
KEYWORDS="~amd64 ~x86 ~arm"
IUSE="cups scanner network"
RESTRICT="mirror strip"
REQUIRED_USE="network? ( cups )"

DEPEND="
	!net-print/samsung-unified-driver:0
	"
RDEPEND="
	cups? (
		net-print/cups
		!net-print/splix
	)
	scanner? (
		media-gfx/sane-backends
		dev-libs/libxml2:2
		virtual/libusb:0
	)
	network? (
		virtual/libusb:0
	)"

S=${WORKDIR}/uld

pkg_setup() {
	if use kernel_linux; then
		linux-info_pkg_setup
		if ! linux_config_exists; then
			ewarn "Can't check the linux kernel configuration."
			ewarn "You might have some incompatible options enabled."
		else
			if use scanner; then
				if linux_chkconfig_present USB_PRINTER; then
					ewarn "You've enabled scanner support, your device will be managed via libusb."
					ewarn "You should disable the USB_PRINTER support in your kernel config."
					ewarn "Please disable it:"
					ewarn "    CONFIG_USB_PRINTER=n"
					ewarn "in /usr/src/linux/.config or"
					ewarn "    Device Drivers --->"
					ewarn "        USB support  --->"
					ewarn "            [ ] USB Printer support"
					ewarn "Scanning WILL NOT work with loaded usblp module."
				fi
			fi
		fi
	fi
}

src_unpack() {
	tar xozf "${DISTDIR}/${A}"
}

src_prepare() {
	default

	find . -type d -exec chmod 755 '{}' \;
	find . -type f -exec chmod 644 '{}' \;
}

src_install() {
	if [ "${ABI}" == "amd64" ]; then
		SARCH="x86_64"
	elif [ "${ABI}" == "x86" ]; then
		SARCH="i386"
	else
		SARCH="arm"
	fi

	# Printing support
	if use cups; then
		# libscmssc.so is now installed by default,
		# though ldd doesn't show any binary that needs it.
		# Apparently it is required for ppds with cms (cts) profile
		# and such drivers won't work otherwise.
		exeinto /usr/$(get_libdir)
		doexe ${SARCH}/libscmssc.so

		exeinto /usr/libexec/cups/filter
		doexe ${SARCH}/pstosecps
		doexe ${SARCH}/rastertospl

		dodir   /usr/share/cups/model/samsung
		insinto /usr/share/cups/model/samsung
		doins noarch/share/ppd/*
		gzip "${D}"/usr/share/cups/model/samsung/*.ppd || die

		dodir   /usr/share/cups/profiles/samsung
		insinto /usr/share/cups/profiles/samsung
		doins noarch/share/ppd/cms/*
	fi

	# Scanning support
	if use scanner; then
		insinto /etc/sane.d
		doins noarch/etc/smfp.conf

		exeinto /usr/$(get_libdir)/sane
		doexe ${SARCH}/libsane-smfp.so.1.0.1

		dosym libsane-smfp.so.1.0.1 /usr/$(get_libdir)/sane/libsane-smfp.so.1
		dosym libsane-smfp.so.1.0.1 /usr/$(get_libdir)/sane/libsane-smfp.so
	fi

	# Network tool
	if use network; then
		exeinto /usr/libexec/cups/backend
		doexe ${SARCH}/smfpnetdiscovery
	fi
}

pkg_postinst() {
	if use scanner; then
		elog "You need to manually add smfp to /etc/sane.d/dll.conf:"
		elog "# echo smfp >> /etc/sane.d/dll.conf"
	fi
}
