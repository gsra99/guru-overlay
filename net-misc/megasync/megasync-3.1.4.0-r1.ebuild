# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils multilib qmake-utils autotools versionator

DESCRIPTION="A Qt-based program for syncing your MEGA account in your PC. This is the official app."
HOMEPAGE="http://mega.co.nz"
if [[ ${PV} == *9999* ]];then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/meganz/MEGAsync"
	KEYWORDS=""
else
	SDK_VERSION="3.2.0"
	SRC_URI="
	https://github.com/meganz/MEGAsync/archive/v${PV}_Linux.tar.gz -> ${P}.tar.gz
	https://github.com/meganz/sdk/archive/v${SDK_VERSION}.tar.gz -> ${PN}-sdk-${SDK_VERSION}.tar.gz
	"
	KEYWORDS="~x86 ~amd64"
	RESTRICT="mirror"
	S="${WORKDIR}/MEGAsync-${PV}_Linux"
fi

LICENSE="MEGA"
SLOT="0"
IUSE="qt5 nautilus freeimage"
DEPEND="
	!qt5? (
		dev-qt/qtcore:4
		dev-qt/qtgui:4
		dev-qt/qtdbus:4
		)
	qt5? (
		dev-qt/qtcore:5
		dev-qt/linguist-tools
		dev-qt/qtwidgets:5
		dev-qt/qtgui:5
		dev-qt/qtconcurrent:5
		dev-qt/qtnetwork:5
		dev-qt/qtdbus:5
		)"
RDEPEND="${DEPEND}
		dev-libs/openssl
		dev-libs/libgcrypt
		media-libs/libpng
		net-dns/c-ares
		dev-libs/crypto++
		app-arch/xz-utils
		dev-libs/libuv
		dev-db/sqlite:3
		dev-libs/libsodium
		sys-libs/zlib
		net-misc/curl[ssl,curl_ssl_openssl]
		freeimage? ( media-libs/freeimage )
		sys-libs/readline:0
		x11-themes/hicolor-icon-theme
		nautilus? (
			>=gnome-base/nautilus-3.12.0
			!!gnome-extra/nautilus-megasync
			)
		"

if [[ ${PV} != *9999* ]];then
	src_prepare(){
		cp -r ../sdk-${SDK_VERSION}/* src/MEGASync/mega
		cd src/MEGASync/mega
		eapply_user
		eautoreconf
	}
fi

src_configure(){
	cd "${S}"/src/MEGASync/mega
	econf \
		"--disable-silent-rules" \
		"--disable-curl-checks" \
		"--disable-megaapi" \
		"--without-termcap" \
		$(use_with freeimage)

	cd ../..
	local myeqmakeargs=(
		MEGA.pro
		CONFIG+="release"
	)
	use nautilus && myeqmakeargs+=( CONFIG+="with_ext" )
	if use qt5; then
		eqmake5 ${myeqmakeargs[@]}
		$(qt5_get_bindir)/lrelease MEGASync/MEGASync.pro
	else
		eqmake4 ${myeqmakeargs[@]}
		$(qt4_get_bindir)/lrelease MEGASync/MEGASync.pro
	fi
}

src_compile(){
	cd "${S}"/src
	emake INSTALL_ROOT="${D}" || die
}

src_install(){
	insinto usr/share/licenses/${PN}
	doins LICENCE.md installer/terms.txt
	cd src/MEGASync
	dobin ${PN}
	cd platform/linux/data
	insinto usr/share/applications
	doins ${PN}.desktop
	cd icons/hicolor
	for size in 16x16 32x32 48x48 128x128 256x256;do
		doicon -s $size $size/apps/mega.png
	done
	if use nautilus; then
		cd "${S}/src/MEGAShellExtNautilus"
		insinto usr/lib/nautilus/extensions-3.0
		doins libMEGAShellExtNautilus.so.1.0.0
		cd data/emblems
		for size in 32x32 64x64;do
			insinto usr/share/icons/hicolor/$size/emblems
			doins $size/mega-{pending,synced,syncing,upload}.{icon,png}
			dosym ${EPREFIX}/usr/lib/nautilus/extensions-3.0/libMEGAShellExtNautilus.so.1.0.0 ${EPREFIX}/usr/lib/nautilus/extensions-3.0/libMEGAShellExtNautilus.so.1.0
			dosym ${EPREFIX}/usr/lib/nautilus/extensions-3.0/libMEGAShellExtNautilus.so.1.0.0 ${EPREFIX}/usr/lib/nautilus/extensions-3.0/libMEGAShellExtNautilus.so.1
			dosym ${EPREFIX}/usr/lib/nautilus/extensions-3.0/libMEGAShellExtNautilus.so.1.0.0 ${EPREFIX}/usr/lib/nautilus/extensions-3.0/libMEGAShellExtNautilus.so
		done
	fi
}
