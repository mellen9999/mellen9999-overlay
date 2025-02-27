# Copyright 2022-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1

DESCRIPTION="File Versioning System with hash comparison"
HOMEPAGE="https://github.com/mirkobrombin/FVS/ https://pypi.org/project/fvs/"
SRC_URI="https://github.com/mirkobrombin/FVS/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

# No tests
RESTRICT="test"

RDEPEND="dev-python/orjson[${PYTHON_USEDEP}]"

S="${WORKDIR}/FVS-${PV}"
