# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-plugins/pidgin-otr/pidgin-otr-3.2.0.ebuild,v 1.9 2012/05/05 05:12:03 jdhore Exp $

EAPI=2

DESCRIPTION="(OTR) Messaging allows you to have private conversations over instant messaging"
HOMEPAGE="http://www.cypherpunks.ca/otr/"
SRC_URI="http://www.cypherpunks.ca/otr/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc sparc x86"
IUSE=""

RDEPEND=">=net-libs/libotr-3.2.0
	x11-libs/gtk+:2
	net-im/pidgin[gtk]"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	patch "${FILESDIR}/${P}-printf.patch"
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc ChangeLog README
}
