# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit git-r3

DESCRIPTION="Google C++ Testing Framework"
HOMEPAGE="https://github.com/google/googletest"
EGIT_REPO_URI="https://github.com/gsra99/cmake-findgmock.git"

LICENSE="BSD"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ~m68k ~mips ppc ppc64 s390 ~sh sparc x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="doc test"

RDEPEND="!dev-cpp/gmock
	>=dev-cpp/gtest-1.8.0[test?,doc?]"

src_install() {
	insinto /usr/share/cmake/Modules
	doins FindGMock.cmake
}
