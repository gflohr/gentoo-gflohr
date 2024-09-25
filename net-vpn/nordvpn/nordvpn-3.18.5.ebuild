# Copyright 2024 Guido Flohr <guido.flohr@cantanea.com>
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit unpacker

DESCRIPTION="The Linux client for NordVPN"
HOMEPAGE="https://nordvpn.com/"
SRC_URI="https://repo.nordvpn.com/deb/nordvpn/debian/pool/main/${PN}_${PV}_amd64.deb"

S="${WORKDIR}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="-* ~x86 amd64"
IUSE="zsh-completion"

RESTRICT="bindist mirror"
QA_PRESTRIPPED="*/usr/bin/nordvpn */usr/sbin/nordvpnd */usr/lib/*"


BDEPEND=""

RDEPEND="
	net-firewall/iptables
	|| ( sys-apps/iproute2 dev-haskell/iproute )
	sys-process/procps
	app-misc/ca-certificates
	dev-libs/libxml2
	net-dns/libidn2
	sys-libs/zlib
"

src_unpack() {
	:
}

src_install() {
	dodir /
	cd "${ED}" || die
	unpacker

	rm -f _gpgorigin || die

	mv usr/share/doc/${PN} usr/share/doc/${PF} || die

	gzip -d usr/share/doc/${PF}/changelog.Debian.gz || die
	gzip -d usr/share/man/man1/${PN}.1.gz || die

}

