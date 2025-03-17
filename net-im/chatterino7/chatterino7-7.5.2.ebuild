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
    llvm? ( llvm-core/clang llvm-core/llvm )
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
    )

    if use llvm; then
        CC="clang"
        CXX="clang++"
    else
        CFLAGS="${CFLAGS} -fno-lto"
        CXXFLAGS="${CXXFLAGS} -fno-lto"
        LDFLAGS="${LDFLAGS} -fno-lto"
    fi


    cmake_src_configure "${mycmakeargs[@]}"
}
