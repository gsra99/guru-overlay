# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

# shellcheck disable=SC2034

EAPI=6

inherit gnome2-utils

DESCRIPTION="Core desktop menu entries and icons for Wine"
HOMEPAGE="https://github.com/bobwya/wine-desktop-common"
RESTRICT="mirror"

if [ "${PV}" = "99999999" ]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/bobwya/${PN}.git"
	SRC_URI=""
else
	KEYWORDS="-* amd64 x86 ~x86-fbsd"
	SRC_URI="https://github.com/bobwya/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
fi

LICENSE="LGPL-2.1"
SLOT="0"
IUSE=""

RDEPEND=""

# These desktop files use a non-standard "Wine" category,
# which is provided by: /etc/xdg/applications-merged/wine.menu
QA_DESKTOP_FILE="
usr/share/wineuninstaller.desktop
usr/share/winecfg.desktop
usr/share/winecontrol.desktop
usr/share/wineexplorer.desktop
usr/share/winetaskmgr.desktop
usr/share/winefile.desktop
usr/share/winemine.desktop
usr/share/winewordpad.desktop
usr/share/winemsiexec.desktop
usr/share/wineiexplore.desktop
usr/share/winewinhelp.desktop
usr/share/winenotepad.desktop
usr/share/wineoleview.desktop
usr/share/wineregedit.desktop
usr/share/wine-mime-msi.desktop
usr/share/winebrowsecdrive.desktop
usr/share/wineboot.desktop
usr/share/winecmd.desktop
"

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
