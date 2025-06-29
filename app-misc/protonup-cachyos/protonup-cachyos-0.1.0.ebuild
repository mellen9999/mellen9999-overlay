EAPI=8

inherit cargo rust

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

CARGO_SRC_DIR="${S}"

src_prepare() {
    default
    cargo_gen_config
    cargo_src_prepare
}

src_compile() {
    export CARGO_NET_OFFLINE=0
    cargo_src_compile
}

