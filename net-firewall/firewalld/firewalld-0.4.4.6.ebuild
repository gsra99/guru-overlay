# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

# ** TO BE DONE: Checking Linux kernel configuration **

EAPI=6

PYTHON_COMPAT=( python{2_7,3_4,3_5,3_6} )

inherit autotools gnome2-utils python-r1 systemd multilib bash-completion-r1

DESCRIPTION="Firewall daemon with D-BUS interface"
HOMEPAGE="http://www.firewalld.org/
	https://github.com/t-woerner/firewalld"
SRC_URI="https://github.com/t-woerner/firewalld/archive/v${PV}.tar.gz
	-> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS=""
IUSE="gui systemd"

COMMON_DEPEND="${PYTHON_DEPS}
	dev-python/dbus-python[${PYTHON_USEDEP}]
	dev-python/decorator[${PYTHON_USEDEP}]
	>=dev-python/python-slip-0.2.7[dbus,${PYTHON_USEDEP}]
	dev-python/pygobject:3[${PYTHON_USEDEP}]
	net-firewall/ebtables
	net-firewall/iptables[ipv6]
	net-firewall/ipset
	gui? ( x11-libs/gtk+:3
		dev-python/PyQt5[${PYTHON_USEDEP}] )
	!systemd? ( >=sys-apps/openrc-0.11.5 )
	systemd? ( sys-apps/systemd )"
DEPEND="${COMMON_DEPEND}
	dev-libs/glib:2
	>=dev-util/intltool-0.35
	dev-libs/libxslt
	sys-devel/gettext"
RDEPEND=${COMMON_DEPEND}

RESTRICT="mirror"

src_prepare() {
	default
	ls po/*.po | sed -e 's/.po//' | sed -e 's/po\///' > po/LINGUAS
	eautoreconf
}

src_configure() {
	python_setup

	econf \
		--disable-sysconfig \
		--disable-rpmmacros \
		$(use_enable systemd) \
		--with-bashcompletiondir="$(get_bashcompdir)" \
		--with-ebtables="${EROOT}sbin/ebtables" \
		--with-ebtables-restore="${EROOT}sbin/ebtables-restore" \
		--with-ip6tables="${EROOT}sbin/ip6tables" \
		--with-ip6tables-restore="${EROOT}sbin/ip6tables-restore" \
		--with-ipset="${EROOT}sbin/ipset" \
		--with-iptables="${EROOT}sbin/iptables" \
		--with-iptables-restore="${EROOT}sbin/iptables-restore" \
		--with-systemd-unitdir="$(systemd_get_systemunitdir)"
}

src_install() {
	# manually split up the installation to avoid "file already exists" errors
	emake -C config DESTDIR="${D}" install
	emake -C po DESTDIR="${D}" install
	emake -C shell-completion DESTDIR="${D}" install
	emake -C doc DESTDIR="${D}" install

	install_python() {
		emake -C src DESTDIR="${D}" pythondir="$(python_get_sitedir)" install
		python_optimize
	}
	python_foreach_impl install_python

	python_replicate_script "${D}"/usr/bin/firewall-{offline-cmd,cmd,applet,config}
	python_replicate_script "${D}/usr/bin/firewallctl"
	python_replicate_script "${D}/usr/sbin/firewalld"

	# Disabling systemd, SysVinit script will be installed. But no sense
	use systemd || rm -rf "${D}/etc/rc.d/"

	# For non-gui installs we need to remove GUI bits
	if ! use gui; then
		rm -rf "${D}/etc/xdg/autostart"
		rm -f "${D}/usr/bin/firewall-applet"
		rm -f "${D}/usr/bin/firewall-config"
		rm -rf "${D}/usr/share/applications"
		rm -rf "${D}/usr/share/icons"
	fi

	newinitd "${FILESDIR}"/firewalld.init firewalld
}

pkg_preinst() {
	gnome2_icon_savelist
	gnome2_schemas_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
	gnome2_schemas_update
}

pkg_postrm() {
	gnome2_icon_cache_update
	gnome2_schemas_update
}
