EAPI=8
inherit meson

DESCRIPTION="A graphical user interface to manage Wine prefixes"
HOMEPAGE="https://usebottles.com/"
SRC_URI="https://github.com/bottlesdevs/Bottles/archive/refs/tags/51.18.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="
  gui-libs/gtk:4
  dev-libs/json-glib
  gui-libs/libadwaita
  dev-libs/libpeas
  app-crypt/libsecret
  x11-libs/libnotify
  dev-libs/libzip
  net-misc/curl
"

RDEPEND="${DEPEND}"
BDEPEND="
  dev-build/meson
  dev-build/ninja
"

S="${WORKDIR}/Bottles-51.18"

src_configure() {
  meson setup "${S}" "${WORKDIR}/${P}-build" --prefix=/usr
}

src_compile() {
  ninja -C "${WORKDIR}/${P}-build"
}

src_install() {
  ninja -C "${WORKDIR}/${P}-build" install
}
