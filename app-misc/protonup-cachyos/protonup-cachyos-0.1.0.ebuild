# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES=""

inherit cargo

DESCRIPTION="A command-line tool for installing and managing Proton-GE, Luxtorpeda, and Wine-GE"
HOMEPAGE="https://github.com/CachyOS/protonup-cachyos"
SRC_URI="
    https://github.com/CachyOS/protonup-cachyos/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
    ${CARGO_CRATE_URIS}
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

# Use rust-bin to avoid source compilation
DEPEND=">=dev-lang/rust-bin-1.70.0"
RDEPEND="${DEPEND}"

BDEPEND="virtual/pkgconfig"

RESTRICT="mirror"

S="${WORKDIR}/${PN}-${PV}"

src_prepare() {
    default
    cargo_src_prepare
}

