# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
IUSE="llvm"

# Inherit CMake and Git eclasses
inherit cmake git-r3

DESCRIPTION="Chat client for Twitch.tv"
HOMEPAGE="https://chatterino.com"
EGIT_REPO_URI="https://github.com/SevenTV/chatterino7.git"
EGIT_COMMIT="v${PV}"  # Verify that Git tags match your version

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
    llvm? ( sys-devel/clang sys-devel/llvm )
"

# Use the same dependency list for build and runtime
DEPEND="${RDEPEND}"

# Build-time dependencies: note the update below!
BDEPEND="
    dev-vcs/git
    dev-build/cmake
"
src_configure() {
    local mycmakeargs=(
        -DBUILD_TESTS=OFF
        -DBUILD_BENCHMARKS=OFF
        -DCHATTERINO_UPDATER=OFF
        -DUSE_SYSTEM_LIBCOMMUNI=OFF
        -DUSE_SYSTEM_QTKEYCHAIN=OFF
        -DUSE_SYSTEM_PAJLADA_SETTINGS=OFF
        -DCMAKE_INTERPROCEDURAL_OPTIMIZATION=OFF
    )

    if use llvm; then
        CC="clang"
        CXX="clang++"
        AR="llvm-ar"
        NM="llvm-nm"
        RANLIB="llvm-ranlib"
    else
        # Disable LTO for GCC
        CFLAGS="${CFLAGS} -fno-lto"
        CXXFLAGS="${CXXFLAGS} -fno-lto"
        LDFLAGS="${LDFLAGS} -fno-lto"
    fi


    cmake_src_configure "${mycmakeargs[@]}"
}

