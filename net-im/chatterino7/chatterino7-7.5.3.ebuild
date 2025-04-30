# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake git-r3 multilib

DESCRIPTION="Chat client for Twitch.tv"
HOMEPAGE="https://chatterino.com"
EGIT_REPO_URI="https://github.com/SevenTV/chatterino7.git"
EGIT_COMMIT="e57eba779dab05fbd3e47dcadacd0b841d8959a7"  # Release v7.5.3

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

# Runtime dependencies
RDEPEND="
    app-crypt/libsecret
    =dev-libs/boost-1.86.0-r1
    dev-libs/openssl
    dev-qt/qtbase:6[concurrent,gui,network,widgets]
    dev-qt/qt5compat:6
    dev-libs/qtkeychain
    dev-qt/qtimageformats:6
    dev-qt/qtsvg:6
    media-libs/libavif
    x11-libs/libnotify
"

# Build-time dependencies
DEPEND="${RDEPEND}
    dev-vcs/git
    dev-util/pkgconf
    dev-build/cmake
"

BDEPEND="
    dev-lang/python:3.12
"

DOCS=( README.md )

src_prepare() {
    cmake_src_prepare

    # Remove bundled Communi detection to build vendored Communi
    sed -i '/find_package(Communi REQUIRED)/d' CMakeLists.txt || die

    # Patch QTextCodec include for Qt6 compatibility
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
        "-DBUILD_TESTS=OFF"
        "-DBUILD_BENCHMARKS=OFF"
        "-DCHATTERINO_UPDATER=OFF"
        "-DUSE_SYSTEM_LIBCOMMUNI=OFF"
        "-DIRC_STATIC=ON"
        "-DUSE_SYSTEM_QTKEYCHAIN=ON"
        "-DUSE_SYSTEM_PAJLADA_SETTINGS=OFF"
    )
    cmake_src_configure "${mycmakeargs[@]}" "${CMAKE_USE_DIR}"
}

src_compile() {
    cmake_src_compile
}

src_install() {
    cmake_src_install
    dodoc README.md
}

