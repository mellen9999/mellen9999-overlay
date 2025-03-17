# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
IUSE="llvm"

inherit cmake git-r3

DESCRIPTION="Chat client for Twitch.tv"
HOMEPAGE="https://chatterino.com"
EGIT_REPO_URI="https://github.com/SevenTV/chatterino7.git"
EGIT_COMMIT="v${PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
    app-crypt/libsecret
    =dev-libs/boost-1.86.0-r1
    dev-libs/openssl
    dev-libs/qtkeychain
    dev-qt/qtbase:6[concurrent,gui,network,widgets]
    dev-qt/qt5compat:6
    dev-qt/qtimageformats:6
    dev-qt/qtsvg:6
    media-libs/libavif
    net-im/libcommuni
    llvm? ( sys-devel/clang sys-devel/llvm )
"

DEPEND="${RDEPEND}"

BDEPEND="
    dev-vcs/git
    dev-build/cmake
"

src_configure() {
    local mycmakeargs=(
        -DBUILD_TESTS=OFF
        -DBUILD_BENCHMARKS=OFF
        -DCHATTERINO_UPDATER=OFF
        -DUSE_SYSTEM_LIBCOMMUNI=ON
        -DUSE_SYSTEM_QTKEYCHAIN=ON
        -DUSE_SYSTEM_PAJLADA_SETTINGS=OFF
        -DLIBCOMMUNI_ROOT=/usr
        -DIrcCore_LIBRARY=/usr/lib64/libIrcCore.so
        -DIrcModel_LIBRARY=/usr/lib64/libIrcModel.so
        -DIrcUtil_LIBRARY=/usr/lib64/libIrcUtil.so
        -DIrcCore_INCLUDE_DIR=/usr/include/qt6/Communi/IrcCore
        -DIrcModel_INCLUDE_DIR=/usr/include/qt6/Communi/IrcModel
        -DIrcUtil_INCLUDE_DIR=/usr/include/qt6/Communi/IrcUtil
        -DQt5Compat_DIR=/usr/lib64/cmake/Qt6Compat
    )

    if use llvm; then
        CC="clang"
        CXX="clang++"
        AR="llvm-ar"
        NM="llvm-nm"
        RANLIB="llvm-ranlib"
    else
        CFLAGS="${CFLAGS} -fno-lto"
        CXXFLAGS="${CXXFLAGS} -fno-lto"
        LDFLAGS="${LDFLAGS} -fno-lto"
    fi

    cmake_src_configure "${mycmakeargs[@]}"
}
