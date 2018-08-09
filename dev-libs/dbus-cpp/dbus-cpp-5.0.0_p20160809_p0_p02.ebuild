# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

URELEASE="zesty"
inherit cmake-utils

UURL="mirror://ubuntu/pool/main/d/dbus-cpp"

# echo "UURL==\"${UURL}\"" >&2

UVER_PREFIX="5.0.0+16.10.20160809"

# echo "UVER_PREFIX==\"${UVER_PREFIX}\""
DESCRIPTION="Dbus-binding leveraging C++-11"
HOMEPAGE="http://launchpad.net/dbus-cpp"
SRC_URI="${UURL}/dbus-cpp_${UVER_PREFIX}.orig.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc examples"
RESTRICT="mirror"

DEPEND="
	dev-libs/boost:=
	sys-apps/dbus
	dev-util/gcovr
	dev-libs/process-cpp"

MAKEOPTS="${MAKEOPTS} -j1"

S="${WORKDIR}"
# /${PN}-${UVER_PREFIX}_p0_p02"


src_prepare() {
	use doc || \
		sed -i 's:add_subdirectory(doc)::g' \
			-i CMakeLists.txt

	use examples || \
		sed -i 's:add_subdirectory(examples)::g' \
			-i CMakeLists.txt

	# Disable '-Werror' #
	sed -e 's/-Werror//g' \
		-i CMakeLists.txt

	# fix dumb hard-coded gmock search paths
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

	export GCOVR_ROOT=/usr

	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DDBUS_CPP_VERSION_MAJOR=5
	)

	cmake-utils_src_configure
}
