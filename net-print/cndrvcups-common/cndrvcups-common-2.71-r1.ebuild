# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit multilib eutils

DESCRIPTION="Common files for the Canon CUPS Capt driver"
HOMEPAGE="http://www.canon.com/"
SRC_URI="http://gdlp01.c-wss.com/gds/6/0100004596/05/linux-capt-drv-v271-uken.tar.gz"

LICENSE="CANON"
SLOT="0"
KEYWORDS="~amd64 ~x86"

MY_P=${P/_p/-}-1

MY_PV="$(ver_rs 1- '')"
SOURCES_NAME="linux-capt-drv-v${MY_PV}-uken"


DOCS="LICENSE-DE.txt LICENSE-EN.txt LICENSE-ES.txt LICENSE-FR.txt \
		LICENSE-IT.txt LICENSE-JP.txt README"

HTML_DOCS=../../Doc/guide-capt-2.7xUK

DEPEND=">=net-print/cups-1.1.17
		>=x11-libs/gtk+-2.4.0
		>=gnome-base/libglade-2.4.0"


S=${WORKDIR}/${SOURCES_NAME}/Src/cndrvcups-common-3.21


src_unpack() {

	if [ "${A}" != "" ]; then
		unpack ${A}
		cd "${WORKDIR}/linux-capt-drv-v271-uken/Src/"
		unpack ./cndrvcups-common-3.21-1.tar.gz
		cd "${WORKDIR}/linux-capt-drv-v271-uken/"

		cd "${WORKDIR}/linux-capt-drv-v271-uken/Doc/"
		unpack ./guide-capt-2.7xUK.tar.gz

		S=${WORKDIR}/${SOURCES_NAME}
	fi
}


src_compile() {

	S=${WORKDIR}/${SOURCES_NAME}/Src/cndrvcups-common-3.21

	cd Src/cndrvcups-common-3.21

	einfo "Configuring: cngplp"
	cd cngplp; LIBS='-lgmodule-2.0 -lgtk-x11-2.0 -lglib-2.0 -lgobject-2.0'  ./autogen.sh --prefix=/usr --libdir=/usr/$(get_libdir)
	emake -j1

	einfo "Configuring: buftool"
	cd ../buftool; ./autogen.sh --prefix=/usr --libdir=/usr/$(get_libdir)
	emake -j1

	einfo "Configuring: backend"
	cd ../backend; ./autogen.sh --prefix=/usr --libdir=/usr/$(get_libdir)
	emake -j1

	einfo "Configuring: c3plmod_ipc"
	cd ../c3plmod_ipc
	emake -j1
}

src_install() {

	emake -j1 DESTDIR="${D}" install


	for i in cngplp buftool backend backend c3plmod_ipc; do
			docinto ${i}
			dodoc ${i}/NEWS ${i}/README ${i}/AUTHORS ${i}/ChangeLog ${i}/LICENSE*
	done

	einstalldocs

	cd c3plmod_ipc
	emake -j1 DESTDIR="${D}" install LIBDIR=/usr/$(get_libdir)
	cd ..

	dobin    libs/c3pldrv
	dolib.so libs/libcaiowrap.so.1.0.0
	dolib.so libs/libcaiousb.so.1.0.0
	dolib.so libs/libc3pl.so.0.0.1
	dolib.so libs/libcaepcm.so.1.0
	dolib.so libs/libColorGear.so.0.0.0
	dolib.so libs/libColorGearC.so.0.0.0
	dolib.so libs/libcanon_slim.so.1.0.0

	dosym /usr/$(get_libdir)/libc3pl.so.0.0.1 /usr/$(get_libdir)/libc3pl.so.0
	dosym /usr/$(get_libdir)/libc3pl.so.0.0.1 /usr/$(get_libdir)/libc3pl.so
	dosym /usr/$(get_libdir)/libcaepcm.so.1.0 /usr/$(get_libdir)/libcaepcm.so.1
	dosym /usr/$(get_libdir)/libcaepcm.so.1.0 /usr/$(get_libdir)/libcaepcm.so

	dosym /usr/$(get_libdir)/libcaiowrap.so.1.0.0 /usr/$(get_libdir)/libcaiowrap.so.1
	dosym /usr/$(get_libdir)/libcaiowrap.so.1.0.0 /usr/$(get_libdir)/libcaiowrap.so
	dosym /usr/$(get_libdir)/libcaiousb.so.1.0.0 /usr/$(get_libdir)/libcaiousb.so.1
	dosym /usr/$(get_libdir)/libcaiousb.so.1.0.0 /usr/$(get_libdir)/libcaiousb.so
	dosym /usr/$(get_libdir)/libcanonc3pl.so.1.0.0 /usr/$(get_libdir)/libcanonc3pl.so.1
	dosym /usr/$(get_libdir)/libcanonc3pl.so.1.0.0 /usr/$(get_libdir)/libcanonc3pl.so
	dosym /usr/$(get_libdir)/libcanon_slim.so.1.0.0 /usr/$(get_libdir)/libcanon_slim.so.1
	dosym /usr/$(get_libdir)/libcanon_slim.so.1.0.0 /usr/$(get_libdir)/libcanon_slim.so

	dosym /usr/$(get_libdir)/libColorGear.so.0.0.0 /usr/$(get_libdir)/libColorGear.so.0
	dosym /usr/$(get_libdir)/libColorGear.so.0.0.0 /usr/$(get_libdir)/libColorGear.so
	dosym /usr/$(get_libdir)/libColorGearC.so.0.0.0 /usr/$(get_libdir)/libColorGearC.so.0
	dosym /usr/$(get_libdir)/libColorGearC.so.0.0.0 /usr/$(get_libdir)/libColorGearC.so


	dodir /usr/share/caepcm
	insinto /usr/share/caepcm
	doins -r data/*.ICC
}
