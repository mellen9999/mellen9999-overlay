EAPI=8

DESCRIPTION="Simple bash script to download latest proton-cachyos"
HOMEPAGE="https://github.com/CachyOS/proton-cachyos"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	net-misc/curl
	app-arch/tar
	app-arch/xz-utils
"

S="${WORKDIR}"

src_unpack() {
	:
}

src_install() {
	newbin "${FILESDIR}/protonup-cachyos" protonup-cachyos
}
