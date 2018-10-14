# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_{5,6,7} )

inherit distutils-r1

DESCRIPTION="A simple yet functional desktop recorder for Linux systems"
HOMEPAGE="http://github.com/green-project/green-recorder"

if [[ ${PV} == *9999* ]];then
	inherit git-r3
	EGIT_REPO_URI="${HOMEPAGE}"
	KEYWORDS=""
else
	SRC_URI="${HOMEPAGE}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~x86 ~amd64"
fi

LICENSE="GPL-3"
SLOT="0"
IUSE=""

DEPEND="${PYTHON_DEPS}
	dev-python/pygobject:3[${PYTHON_USEDEP}]
	x11-libs/gtk+:3
	dev-libs/libappindicator:3
	dev-python/pydbus
	dev-python/urllib3[${PYTHON_USEDEP}]
	"
RDEPEND="${DEPEND}
	virtual/ffmpeg
	sys-apps/gawk
	x11-apps/xwininfo
	"
