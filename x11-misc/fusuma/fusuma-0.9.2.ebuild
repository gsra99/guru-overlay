# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
USE_RUBY="ruby22 ruby23 ruby24 ruby25"
inherit ruby-fakegem

DESCRIPTION=" Multitouch gestures with libinput driver on X11"
HOMEPAGE="https://github.com/iberianpig/fusuma"
SRC_URI="https://github.com/iberianpig/fusuma/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE=""
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="x11-misc/xdotool
	>=dev-libs/libinput-1.8.0"

all_ruby_install() {
	ruby_fakegem_binwrapper fusuma /usr/local/bin/fusuma
}
