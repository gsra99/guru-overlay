# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit linux-info git-r3 systemd

DESCRIPTION="Daemon for Bluetooth devices with HSP and HFP profiles"
HOMEPAGE="https://github.com/pali/hsphfpd-prototype"
EGIT_REPO_URI="https://github.com/pali/hsphfpd-prototype.git"

LICENSE="Unlicense"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
	dev-lang/perl
	dev-perl/Net-DBus
	sys-apps/dbus"
BDEPEND=""

pkg_setup() {
	CONFIG_CHECK="~DEBUG_FS ~BT_DEBUGFS"
	linux-info_pkg_setup
}

src_install() {
	# install dbus interface
	insinto /etc/dbus-1/system.d/
	doins org.hsphfpd.conf

	# install daemon
	exeinto /usr/bin
	doexe hsphfpd.pl

	# install init script
	newinitd "${FILESDIR}/${PN}.initd" ${PN}

	# install systemd service
	systemd_dounit "${FILESDIR}/${PN}.service"
}
