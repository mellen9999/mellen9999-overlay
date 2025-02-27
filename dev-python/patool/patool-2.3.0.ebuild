# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1 pypi

DESCRIPTION="Portable archive file management in Python"
HOMEPAGE="https://wummel.github.io/patool/ https://pypi.org/project/patool/"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

# No tests in PyPI tarball
RESTRICT="test"

# Optional runtime dependencies for various archive formats
RDEPEND="
    app-arch/unzip
    app-arch/p7zip
    app-arch/rar
    app-arch/tar
    app-arch/gzip
    app-arch/bzip2
    app-arch/xz-utils
    app-arch/lzip
    app-arch/lzma
    app-arch/lzop
    app-arch/zstd
"

src_install() {
    distutils-r1_src_install
}
