# Copyright 2024 Guido Flohr <guido.flohr@cantanea.com>
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Guido's custom Hello World package"
HOMEPAGE="https://www.guido-flohr.net"
SRC_URI=""

LICENSE=""
SLOT="0"
KEYWORDS="amd64 x86"

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND=""

src_install() {
    echo "Hello, Guido!" > "${D}/usr/bin/hello-guido"
    chmod +x "${D}/usr/bin/hello-guido"
}
