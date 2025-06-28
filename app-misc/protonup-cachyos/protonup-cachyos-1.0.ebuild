EAPI=8

DESCRIPTION="Auto-installer for latest CachyOS Proton-GE build"
HOMEPAGE="https://github.com/CachyOS/proton-cachyos"
SRC_URI=""

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND="app-arch/tar
         app-arch/xz-utils
         net-misc/curl
         app-misc/jq
         sys-apps/coreutils
         sys-process/procps"

S=${WORKDIR}

src_install() {
    exeinto /usr/bin
    doexe "${FILESDIR}/protonup-cachyos"
}

