# Copyright 2024 Guido Flohr <guido.flohr@cantanea.com>
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit unpacker

DESCRIPTION="The Linux client for NordVPN"
HOMEPAGE="https://nordvpn.com/"
SRC_URI="
	https://github.com/NordSecurity/${PN}-linux/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz
"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="-* amd64"
IUSE="zsh-completion"

BDEPEND="
	>=dev-lang/go-1.22.2
"

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

src_configure() {
	# This is what the Debian binary uses.
	export NORDVPN_SALT=charmgoofyropegritmamatilt
	export NORDVPN_VERSION="${PV}"
	export NORDVPN_ENVIRONMENT=prod
	# Also taken from Debian.
	export NORDVPN_HASH=ce61504
	export NORDVPN_ARCH=i386
	# FIXME! Is this correct?
	export NORDVPN_PACKAGE_TYPE=ebuild

	export CGO_ENABLED=1
	export CGO_CFLAGS="${CFLAGS}"
	export CGO_CPPFLAGS="${CPPFLAGS}"
	export CGO_CXXFLAGS="${CXXFLAGS}"
	export CGO_LDFLAGS="${LDFLAGS}"

	export COMMON_LDFLAGS="
		-X main.Version=${NORDVPN_VERSION}
		-X main.Environment=${NORDVPN_ENVIRONMENT}
		-X main.Hash=${NORDVPN_HASH}
		-X main.Salt=${NORDVPN_SALT}
	"
	export NORDVPN_COMMON_LDFLAGS="${LDFLAGS} ${COMMON_LDFLAGS}"

	default
}

src_compile() {
	ego build -ldflags="-buildmode=pie -s -w -linkmode=external \
		-X main.Version=${NORDVPN_VERSION} \
		-X main.Environment=${NORDVPN_ENVIRONMENT} \
		-X main.Hash=${NORDVPN_HASH} \
		-X main.Salt=${NORDVPN_SALT} \
		" -o bin/nordvpn ./cmd/cli
	ego build -ldflags="-buildmode=pie -s -w -linkmode=external \
		-tags=drop,moose,telio \
		-X main.Version=${NORDVPN_VERSION} \
		-X main.Environment=${NORDVPN_ENVIRONMENT} \
		-X main.Arch=${NORDVPN_ARCH} \
		-X main.Salt=${NORDVPN_SALT} \
		-X main.PackageType=${NORDVPN_PACKAGE_TYPE}
		" -o bin/nordvpnd ./cmd/daemon
}

src_install() {
	dobin bin/nordvpn
	dosbin bin/nordvpnd
}

