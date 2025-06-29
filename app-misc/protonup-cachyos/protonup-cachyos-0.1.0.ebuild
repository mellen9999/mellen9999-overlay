EAPI=8

inherit cargo git-r3

DESCRIPTION="tool to install latest protonup-cachyos"
HOMEPAGE="https://github.com/CachyOS/ProtonUp-Qt"
SRC_URI="https://github.com/CachyOS/ProtonUp-Qt/archive/refs/tags/v0.1.0.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="
    dev-libs/glib
"
DEPEND="${RDEPEND}"

# Ensure we use crates.io as the source, not offline overlays
CARGO_SRC_DIR="${S}"

src_unpack() {
    default
}

src_prepare() {
    default
    cargo_gen_config
    cargo_src_prepare
}

