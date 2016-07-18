# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

PYTHON_COMPAT=( python2_7 )
DISTUTILS_IN_SOURCE_BUILD=1
inherit distutils-r1

DESCRIPTION="Compizconfig Settings Manager"
HOMEPAGE="https://github.com/compiz-reloaded/ccsm"
SRC_URI="https://github.com/compiz-reloaded/ccsm/releases/download/v${PV}/ccsm-${PV}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="-*"
IUSE="gtk3"

# FIXME : (Myu): (regarding pygobject) Needed introspections for ccsm: GLib, Gtk, Gdk, GdkX11, GdkPixbuf, Pango, PangoCairo ( XRevan86 IRC ) 
# FIXME : (nasaiya): does this mean we need additional deps?
# FIXME : (nasaiya): is pycairo just for gtk3?
RDEPEND="
	>=compiz-reloaded/compizconfig-python-0.8.12[${PYTHON_USEDEP}]
	!gtk3? ( >=dev-python/pygtk-2.12:2[${PYTHON_USEDEP}] )
	gtk3? ( 
            dev-python/pygobject 
            dev-python/pycairo 
        )
	gnome-base/librsvg
"

DOCS=( AUTHORS )

python_prepare_all() {
	# return error if wrong arguments passed to setup.py
	sed -i -e 's/raise SystemExit/\0(1)/' setup.py || die 'sed on setup.py failed'

	# correct gettext behavior
	if [[ -n "${LINGUAS+x}" ]] ; then
		for i in $(cd po ; echo *po | sed 's/\.po//g') ; do
		if ! has ${i} ${LINGUAS} ; then
			rm po/${i}.po || die
		fi
		done
	fi

	distutils-r1_python_prepare_all
}

python_configure_all() {
        local myconf=""
        use gtk3 && myconf+=" --with-gtk=3.0"
        use gtk3 || myconf+=" --with-gtk=2.0"
        
        mydistutilsargs=( build \
            --prefix=/usr \
            ${myconf}
        )
}

pkg_postinst() {
    gtk-update-icon-cache

    elog "Do NOT report bugs about this package!"
    elog "This is a homebrewed ebuild and is not"
    elog "maintained by anyone. In fact, it might"
    elog "self-destruct at any moment... :)"
}
