# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/dropbox/dropbox-2.10.41-r1.ebuild,v 1.1 2015/02/16 17:17:44 swift Exp $

EAPI=5

inherit eutils systemd

DESCRIPTION="Dropbox daemon (pretends to be GUI-less)"
HOMEPAGE="http://dropbox.com/"
SRC_URI="https://copy.com/install/linux/Copy.tgz -> ${PF}.tgz"

LICENSE="CC-BY-ND-3.0 FTL MIT LGPL-2 openssl dropbox"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~arm"
IUSE=""
RESTRICT="mirror"

DEPEND=""

RDEPEND=""

S="${WORKDIR}/copy"

src_unpack() {
	unpack ${A}
	local sourcedir="x86? ( ${S}/x86 )
			 amd64? ( ${S}/x86_64 )
			 arm? ( ${S}/armv6h )"
}

src_install() {
	local targetdir="/opt/copy_agent"

	insinto "${targetdir}"
	doins -r *
	#fperms a+x "${targetdir}"/{dropbox,dropboxd}
	dosym "${targetdir}/CopyAgent" "/opt/bin/copyagent"
	dosym "${targetdir}/CopyCmd" "/opt/bin/copycmd"
	dosym "${targetdir}/CopyConsole" "/opt/bin/copyconsole"

	systemd_newunit "${FILESDIR}"/copy_agent_at.service "copy_agent@.service"
	newinitd "${FILESDIR}"/copy_agent.initd copy_agent
	newconfd "${FILESDIR}"/copy_agent.conf copy_agent

	dodoc "${T}"/README
}

#pkg_preinst() {
#	gnome2_icon_savelist
#}

#pkg_postinst() {
#	gnome2_icon_cache_update
#}

#pkg_postrm() {
#	gnome2_icon_cache_update
#}
