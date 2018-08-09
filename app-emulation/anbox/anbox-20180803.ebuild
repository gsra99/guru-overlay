# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=6

PYTHON_COMPAT=(python2_7)

inherit python-single-r1 cmake-utils git-r3 linux-info systemd udev versionator

DESCRIPTION="Run Android applications on any GNU/Linux operating system"
HOMEPAGE="https://anbox.io/"
SRC_URI="https://build.anbox.io/android-images/2017/07/13/android_3_amd64.img"
EGIT_REPO_URI="https://github.com/${PN}/${PN}.git"
EGIT_BRANCH="master"
EGIT_COMMIT="2dea391b24f66c78d8c68e44bc1776913a9a3a4d"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

RDEPEND="dev-util/android-tools
	net-firewall/iptables
	dev-libs/dbus-cpp"

DEPEND="${RDEPEND}
	${PYTHON_DEPS}
	app-emulation/anbox-modules
	app-emulation/lxc
	dev-libs/boost:=[threads]
	dev-libs/glib:2
	dev-libs/properties-cpp
	dev-libs/process-cpp
	dev-libs/protobuf
	media-libs/libsdl2[wayland]
	media-libs/mesa[egl,gles2]
	media-libs/sdl2-image
	sys-apps/dbus
	sys-libs/libcap
	sys-apps/systemd[nat]
	dev-cpp/gtest"

CONFIG_CHECK="
	~NAMESPACES
	~IPC_NS
	~NET_NS
	~PID_NS
	~USER_NS
	~UTS_NS
	~BRIDGE
	~NF_NAT_MASQUERADE_IPV4
	~!BINDER
	~!ASHMEM
"

pkg_setup() {
	linux-info_pkg_setup
	python-single-r1_pkg_setup
}

src_prepare() {
	cmake-utils_src_prepare

	truncate -s0 cmake/FindGMock.cmake tests/CMakeLists.txt
}

src_install() {
	cmake-utils_src_install

	# 'anbox-container-manager.service' is started as root #
	systemd_dounit "${FILESDIR}"/anbox-container-manager.service
	# systemd_enable_service default anbox-container-manager.service
	# insinto $(systemd_get_systemunitdir)
	# doins "${FILESDIR}/anbox-container-manager.service"
	# dosym $(systemd_get_systemunitdir)/anbox-container-manager.service \
	# $(systemd_get_systemunitdir)/default.target.wants/anbox-container-manager.service

	systemd_douserunit "${FILESDIR}"/anbox-session-manager.service

	# 'anbox-session-manager.service' is started as user #
	insinto $(systemd_get_userunitdir)
	doins "${FILESDIR}/anbox-session-manager.service"
	# dosym $(systemd_get_userunitdir)/anbox-session-manager.service \
	# $(systemd_get_userunitdir)/default.target.wants/anbox-session-manager.service

	# 'anbox0' network interface #
	insinto $(systemd_get_utildir)/network
	doins "${FILESDIR}/80-anbox-bridge.network"
	doins "${FILESDIR}/80-anbox-bridge.netdev"
	# dosym $(systemd_get_systemunitdir)/systemd-networkd.service \
	# $(systemd_get_systemunitdir)/default.target.wants/systemd-networkd.service

	# anbox.desktop and icon #
	insinto /usr/share/applications
	doins "${FILESDIR}/anbox.desktop"
	insinto /usr/share/pixmaps
	newins snap/gui/icon.png anbox.png

	insinto /var/lib/anbox
	newins "${DISTDIR}"/android_amd64.img android.img
	fowners -Rc root:users /var/lib/anbox || die
	fperms -Rc g+w /var/lib/anbox  || die

	# now done in anbox-modules
	# udev_dorules kernel/99-anbox.rules
}
