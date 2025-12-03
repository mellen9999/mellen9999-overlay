# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake git-r3

DESCRIPTION="Chat client for Twitch.tv with 7TV emote support"
HOMEPAGE="https://chatterino.com"
EGIT_REPO_URI="https://github.com/SevenTV/chatterino7.git"
EGIT_COMMIT="ddc4d3357aedbafe0883c298aeadceb31099ffea"  # Release v7.5.4

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-libs/openssl:=
	dev-libs/qtkeychain:=
	dev-qt/qt5compat:6
	dev-qt/qtbase:6[concurrent,gui,network,widgets]
	dev-qt/qtimageformats:6
	dev-qt/qtsvg:6
	media-libs/libavif
	x11-libs/libnotify
"
DEPEND="
	${RDEPEND}
	dev-libs/boost
"
BDEPEND="dev-qt/qttools:6[linguist]"

src_prepare() {
	cmake_src_prepare

	# Build vendored Communi
	sed -i '/find_package(Communi REQUIRED)/d' CMakeLists.txt || die

	# Qt6 compatibility for QTextCodec
	sed -i \
		-e '/#include <QTextCodec>/c\
#if QT_VERSION < QT_VERSION_CHECK(6,0,0)\
#include <QTextCodec>\
#else\
#include <QtCore5Compat/QTextCodec>\
#endif' \
		src/util/XDGHelper.cpp || die
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_TESTS=OFF
		-DBUILD_BENCHMARKS=OFF
		-DCHATTERINO_UPDATER=OFF
		-DUSE_SYSTEM_LIBCOMMUNI=OFF
		-DIRC_STATIC=ON
		-DUSE_SYSTEM_QTKEYCHAIN=ON
		-DUSE_SYSTEM_PAJLADA_SETTINGS=OFF
	)
	cmake_src_configure
}
