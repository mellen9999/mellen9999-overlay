EAPI=8

inherit cmake

DESCRIPTION="Chatterino fork with 7tv support"
HOMEPAGE="https://github.com/SevenTV/chatterino7"
SRC_URI="https://github.com/SevenTV/chatterino7/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="
    dev-qt/qtcore:6
    dev-qt/qtgui:6[wayland]
    dev-qt/qtwidgets:6
    dev-qt/qtmultimedia:6
    dev-qt/qtsvg:6
    dev-qt/qtnetwork:6
    dev-libs/openssl:=
    dev-libs/boost:=
    gui-libs/libadwaita
"
RDEPEND="${DEPEND}"

S="${WORKDIR}/chatterino7-${PV}"

src_configure() {
    cmake_src_configure
}
