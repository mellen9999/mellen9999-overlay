EAPI=8

inherit cmake

DESCRIPTION="Chatterino fork with 7tv support"
HOMEPAGE="https://github.com/SevenTV/chatterino7"
SRC_URI="https://github.com/SevenTV/chatterino7/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
    app-crypt/libsecret
    dev-libs/boost
    dev-libs/openssl
    dev-libs/qtkeychain
    dev-qt/qt5compat:6
    dev-qt/qtbase:6
    dev-qt/qtwayland:6
    dev-qt/qtsvg:6
    media-libs/libavif
    net-im/libcommuni
"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${P}"

src_configure() {
    cmake_src_configure
}
