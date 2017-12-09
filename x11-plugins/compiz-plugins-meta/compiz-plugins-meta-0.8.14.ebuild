# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="6"

DESCRIPTION="Compiz plugins (meta)"
HOMEPAGE="https://github.com/compiz-reloaded"
SRC_URI=""

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="compicc experimental extra"

RDEPEND="
	>=x11-plugins/compiz-plugins-main-${PV}
	compicc? ( >=x11-plugins/compicc-0.8.10 )
	experimental? ( >=x11-plugins/compiz-plugins-experimental-${PV} )
	extra? ( >=x11-plugins/compiz-plugins-extra-${PV} )
"
