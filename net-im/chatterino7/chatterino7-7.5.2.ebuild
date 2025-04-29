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
    app-crypt/libsecret
    dev-libs/boost
    dev-libs/openssl
    dev-libs/qtkeychain
    dev-qt/qt5compat:6
    dev-qt/qtimageformats:6
    media-libs/libavif
    net-im/libcommuni
"
RDEPEND="${DEPEND}"

S="${WORKDIR}/chatterino7-${PV}"

src_configure() {
    cmake_src_configure
}
