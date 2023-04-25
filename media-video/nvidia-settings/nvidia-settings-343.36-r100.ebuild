# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop toolchain-funcs xdg

DESCRIPTION="NVIDIA driver control panel"
HOMEPAGE="https://www.nvidia.com/"
SRC_URI="https://download.nvidia.com/XFree86/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0/${PV%%.*}"
KEYWORDS="amd64 x86"

DEPEND="
	dev-libs/jansson
	media-libs/libglvnd
	x11-libs/gdk-pixbuf:2
	x11-base/xorg-proto
	dev-libs/glib:2
	x11-libs/gtk+:3
	x11-libs/libvdpau
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXrandr
	x11-libs/libXv
	x11-libs/libXxf86vm
	x11-libs/pango
"
RDEPEND="${DEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}/nvidia-settings-fno-common.patch"
	"${FILESDIR}/nvidia-settings-343.36-backport-340.108-changes.patch"
)

src_prepare() {
	default

	# Force GTK+ 3
	sed -i "s/gtk+-2.0/gtk+-3.0/g" src/Makefile || die

	# Fix nvidia-settings.desktop
	sed -e '/Exec=\|Icon=/s/_.*/nvidia-settings/' \
		-e '/Categories=/s/_.*/System;Settings;/' \
		-i doc/nvidia-settings.desktop || die
}

src_compile() {
	emake \
		HOST_CC="$(tc-getBUILD_CC)" \
		HOST_LD="$(tc-getBUILD_LD)" \
		NV_USE_BUNDLED_LIBJANSSON=0 \
		NV_VERBOSE=1 STRIP_CMD="true" OUTPUTDIR=out
}

src_install() {
	emake install \
		DESTDIR="${D}" \
		PREFIX="${EPREFIX}/usr" \
		NV_VERBOSE=1 MANPAGE_GZIP=0 STRIP_CMD="true" OUTPUTDIR=out

	doicon doc/nvidia-settings.png
	domenu doc/nvidia-settings.desktop

	exeinto /etc/X11/xinit/xinitrc.d
	doexe "${FILESDIR}"/95-nvidia-settings
}
