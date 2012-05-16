# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/poc/poc-0.4.1.ebuild,v 1.4 2007/08/01 14:21:48 drac Exp $

inherit eutils toolchain-funcs

DESCRIPTION="mp3 and ogg streamer (include mp3cue and mp3cut)"
HOMEPAGE="http://www.bl0rg.net/software/poc"
SRC_URI="http://www.bl0rg.net/software/${PN}/${P}.tar.gz"
EAPI="3"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="id3 ipv6 ssl +mp3cue-long-strings"

RDEPEND=""
DEPEND="sys-devel/flex
	sys-devel/bison
	id3? ( media-libs/libid3tag )
	ssl? ( dev-libs/openssl )
"

src_unpack() {
	unpack ${A}
	cd "${S}"
	sed -i \
		-e '/^CFLAGS/s:-O2::' \
		-e '/^PREFIX/s:/local::' \
		Makefile
	epatch "${FILESDIR}"/${P}-fec-pkt-prototype.patch
	epatch "${FILESDIR}"/${P}-file-perms.patch
	epatch "${FILESDIR}"/${P}-msc-to-msf.patch
	if use id3; then
		sed -i \
		-e '/CFLAGS += -DWITH_ID3TAG/s/^#//' \
		-e '/LDFLAGS += -lid3tag/s/^#//' \
		Makefile
	fi
	if use ipv6; then
		sed -i \
		-e '/CFLAGS+=-DWITH_IPV6/s/^#//' \
		Makefile
	fi
	if use ssl; then
		sed -i \
		-e '/CFLAGS+=-DWITH_OPENSSL/s/^#//' \
		-e '/LDFLAGS+=-lssl -lcrypto/s/^#//' \
		Makefile
	fi
	if use mp3cue-long-strings; then
		sed -i \
		-e '/#define MP3CUE_MAX_STRING_LENGTH/s/64/128/' \
		mp3cue.h
	fi
}

src_compile() {
	emake CC="$(tc-getCC)" || die "emake failed."
}

src_install() {
	dodir /usr/bin /usr/share/man/man1
	emake DESTDIR="${D}" install || die "emake install failed."
	dodoc README TODO
}
