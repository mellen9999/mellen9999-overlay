# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake git-r3

DESCRIPTION="Chatterino fork with 7tv support"
HOMEPAGE="https://github.com/SevenTV/chatterino7"
EGIT_REPO_URI="https://github.com/SevenTV/chatterino7.git"
EGIT_COMMIT="v${PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
    app-crypt/libsecret
    =dev-libs/boost-1.86.0-r1
    dev-libs/openssl
    dev-libs/qtkeychain[qt6]
    dev-qt/qt5compat:6
    dev-qt/qtbase:6[concurrent,gui,network,wayland,widgets]
    dev-qt/qtimageformats:6
    dev-qt/qtsvg:6
    media-libs/libavif
    net-im/libcommuni
"
BDEPEND="dev-vcs/git"
RDEPEND="${DEPEND}"

src_prepare() {
    cmake_src_prepare
    # fetch submodules
    git submodule update --init --recursive
}

src_configure() {
    local mycmakeargs=(
        -DBUILD_TESTS=OFF
        -DBUILD_BENCHMARKS=OFF
        -DCHATTERINO_UPDATER=OFF
        -DUSE_SYSTEM_LIBCOMMUNI=OFF
        -DUSE_SYSTEM_QTKEYCHAIN=OFF
        -DUSE_SYSTEM_PAJLADA_SETTINGS=OFF
    )
    cmake_src_configure "${mycmakeargs[@]}"
}
