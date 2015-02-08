# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit autotools eutils libtool gnome2 mate-desktop.org

# FIXME Not all package have proper build system/docs
# Once this is fixed upstream remove DEPEND and move to ebuild.
DEPEND="dev-util/gtk-doc
		dev-util/gtk-doc-am"

# @FUNCTION: mate_gen_build_system
# @DESCRIPTION:
# Generate autotools build system for releases that don't have one.
# We need this as early releases did not have a proper build system.
mate_gen_build_system() {
	einfo "Generating mate build system"
	# Retrieve configure script
		local mate_conf_in
		if [[ -f "${S}/configure.in" ]]; then
			mate_conf_in="${S}/configure.in"
		elif [[ -f "${S}/configure.ac" ]]; then
			mate_conf_in="${S}/configure.ac"
		else
			einfo "no configure.in or configure.ac file were found"
			return 0
		fi
		# Mate preparation, doing similar to autotools eclass stuff. (Do we need die here?)
		if grep -q "^AM_GLIB_GNU_GETTEXT" "${mate_conf_in}"; then
			autotools_run_tool glib-gettextize --copy --force || die
		elif grep -q "^AM_GNU_GETTEXT" "${mate_conf_in}"; then
			eautopoint --force
		fi

		if grep -q "^A[CM]_PROG_LIBTOOL" "${mate_conf_in}" || grep -q "^LT_INIT" "${mate_conf_in}"; then
			_elibtoolize --copy --force --install
		fi


		if grep -q "^AC_PROG_INTLTOOL" "${mate_conf_in}" || grep -q "^IT_PROG_INTLTOOL" "${mate_conf_in}"; then
			mkdir -p "${S}/m4"
			autotools_run_tool intltoolize --automake --copy --force || die
		fi

		if grep -q "^GTK_DOC_CHECK" "${mate_conf_in}"; then
			autotools_run_tool gtkdocize --copy || die
		fi

		if grep -q "^MATE_DOC_INIT" "${mate_conf_in}"; then
			autotools_run_tool mate-doc-prepare --force --copy || die
			autotools_run_tool mate-doc-common --copy || die
		fi

		eaclocal
		eautoconf
		eautoheader
		eautomake
}
