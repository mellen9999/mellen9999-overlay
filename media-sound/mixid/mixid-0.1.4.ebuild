# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Unofficial Linux control panel for Audient iD series audio interfaces"
HOMEPAGE="https://github.com/TheOnlyJoey/MixiD"

IMGUI_PV="1.92.4"
SRC_URI="
	https://github.com/TheOnlyJoey/MixiD/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/ocornut/imgui/archive/refs/tags/v${IMGUI_PV}.tar.gz -> imgui-${IMGUI_PV}.tar.gz
"
S="${WORKDIR}/MixiD-${PV}"

# Upstream has no LICENSE file - assuming all-rights-reserved until clarified
# imgui is MIT licensed
LICENSE="all-rights-reserved MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-libs/libusb:1
	media-libs/glew:0=
	media-libs/glfw:0=
	virtual/opengl
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

src_prepare() {
	# Replace FetchContent with pre-downloaded imgui
	sed -i \
		-e '/include(FetchContent)/d' \
		-e "/FetchContent_Declare/,/FetchContent_MakeAvailable/c\set(imgui_external_SOURCE_DIR \"${WORKDIR}/imgui-${IMGUI_PV}\")" \
		CMakeLists.txt || die

	# Build imgui as static library to avoid system imgui version conflicts
	sed -i 's/add_library(imgui$/add_library(imgui STATIC/' CMakeLists.txt || die

	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_BUILD_TYPE=Release
	)
	cmake_src_configure
}

src_install() {
	dobin "${BUILD_DIR}"/MixiD

	# Install udev rules for USB device access
	insinto /usr/lib/udev/rules.d
	newins - 70-audient.rules <<-EOF
		# Audient iD series interfaces
		SUBSYSTEM=="usb", ATTR{idVendor}=="2708", MODE="0666"
	EOF
}
