# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cargo

DESCRIPTION="Install and manage custom versions of Proton-GE and Wine-GE"
HOMEPAGE="https://github.com/CachyOS/ProtonUp-CachyOS"
SRC_URI="https://github.com/CachyOS/ProtonUp-CachyOS/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

BDEPEND="virtual/rust"

CARGO_SRC_DIR="${S}"

src_prepare() {
    default
    cargo_src_prepare
}

src_install() {
    dobin target/release/protonup-cachyos
    dodoc README.md
}
