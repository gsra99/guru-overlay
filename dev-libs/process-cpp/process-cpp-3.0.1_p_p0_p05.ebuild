# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

URELEASE="zesty"
inherit cmake-utils

UURL="mirror://ubuntu/pool/main/p/${PN}"

DESCRIPTION="C++11 library for handling processes"
HOMEPAGE="http://launchpad.net/process-cpp"
SRC_URI="${UURL}/${PN}_3.0.1.orig.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

DEPEND="dev-libs/boost:=
	dev-libs/properties-cpp"

S="${WORKDIR}/${PN}-3.0.1"

src_prepare() {
	sed -e 's|usr/src/gmock/gtest/include|usr/include/gmock|' \
		-i cmake/FindGtest.cmake
	sed -e 's|usr/src|usr|' \
		-i cmake/FindGtest.cmake
	sed -e 's|GMOCK_PREFIX gmock|GMOCK_PREFIX ""|' \
		-i cmake/FindGtest.cmake
	sed -e '/^#gmock/,/^set/d' \
		-i cmake/FindGtest.cmake
	sed -e '/^ExternalProject_Add/,/^set/d' \
		-i cmake/FindGtest.cmake
	sed -e '/^add_subdirectory.tests/d' \
		-i CMakeLists.txt
	rm -rvf tests
	export GMOCK_INSTALL_DIR=/usr
	export GMOCK_PREFIX=/
	export GMOCK_BINARY_DIR=/usr/bin
	export GTEST_INCLUDE_DIR=/usr/include/gtest
	cmake-utils_src_prepare
}
