# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emulation/wine/wine-1.5.5.ebuild,v 1.1 2012/05/28 04:02:24 tetromino Exp $

EAPI="5"

inherit autotools eutils flag-o-matic multilib pax-utils

if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="git://source.winehq.org/git/wine.git"
	inherit git-2
	SRC_URI=""
	#KEYWORDS=""
else
	MY_P="${PN}-${PV/_/-}"
	SRC_URI="mirror://sourceforge/${PN}/Source/${MY_P}.tar.bz2"
	KEYWORDS="-* ~amd64 ~x86 ~x86-fbsd"
	S=${WORKDIR}/${MY_P}
fi

GV="1.5"
DESCRIPTION="free implementation of Windows(tm) on Unix"
HOMEPAGE="http://www.winehq.org/"
SRC_URI="${SRC_URI}
	gecko? (
		mirror://sourceforge/wine/wine_gecko-${GV}-x86.msi
		win64? ( mirror://sourceforge/wine/wine_gecko-${GV}-x86_64.msi )
	)"

LICENSE="LGPL-2.1"
SLOT="0"
IUSE="alsa capi cups custom-cflags elibc_glibc fontconfig +gecko gnutls gphoto2 gsm gstreamer hardened jpeg lcms ldap mp3 ncurses nls odbc openal opencl +opengl +oss +perl png samba scanner selinux ssl test +threads +truetype udisks v4l +win32 +win64 +X xcomposite xinerama xml"
REQUIRED_USE="elibc_glibc? ( threads )" #286560
RESTRICT="test" #72375

MLIB_DEPS="amd64? (
			truetype? ( || (
				>=app-emulation/emul-linux-x86-xlibs-2.1[development,-abi_x86_32(-)]
				>=media-libs/freetype-2.5.0.1[abi_x86_32(-)]
			) )
			ncurses? ( || (
				app-emulation/emul-linux-x86-baselibs[development,-abi_x86_32(-)]
				>=sys-libs/ncurses-5.9-r3[abi_x86_32(-)]
			) )
			udisks? ( || (
				>=app-emulation/emul-linux-x86-baselibs-20130224[development,-abi_x86_32(-)]
				>=sys-apps/dbus-1.6.18-r1[abi_x86_32(-)]
			) )
			fontconfig? ( || (
				app-emulation/emul-linux-x86-xlibs[development,-abi_x86_32(-)]
				>=media-libs/fontconfig-2.10.92[abi_x86_32(-)]
			) )
			gphoto2? ( || (
				app-emulation/emul-linux-x86-medialibs[development,-abi_x86_32(-)]
				>=media-libs/libgphoto2-2.5.3.1[abi_x86_32(-)]
			) )
			openal? ( || (
				app-emulation/emul-linux-x86-sdl[development,-abi_x86_32(-)]
				>=media-libs/openal-1.15.1[abi_x86_32(-)]
			) )
			gstreamer? ( || (
				app-emulation/emul-linux-x86-medialibs[development,-abi_x86_32(-)]
				(
					>=media-libs/gstreamer-0.10.36-r2:0.10[abi_x86_32(-)]
					>=media-libs/gst-plugins-base-0.10.36:0.10[abi_x86_32(-)]
				)
			) )
			X? ( || (
				app-emulation/emul-linux-x86-xlibs[development,-abi_x86_32(-)]
				(
					>=x11-libs/libXcursor-1.1.14[abi_x86_32(-)]
					>=x11-libs/libXext-1.3.2[abi_x86_32(-)]
					>=x11-libs/libXrandr-1.4.2[abi_x86_32(-)]
					>=x11-libs/libXi-1.7.2[abi_x86_32(-)]
					>=x11-libs/libXxf86vm-1.1.3[abi_x86_32(-)]
				)
			) )
			xinerama? ( || (
				app-emulation/emul-linux-x86-xlibs[development,-abi_x86_32(-)]
				>=x11-libs/libXinerama-1.1.3[abi_x86_32(-)]
			) )
			alsa? ( || (
				app-emulation/emul-linux-x86-soundlibs[alsa,development,-abi_x86_32(-)]
				>=media-libs/alsa-lib-1.0.27.2[abi_x86_32(-)]
			) )
			cups? ( || (
				app-emulation/emul-linux-x86-baselibs
				>=net-print/cups-1.7.1-r1[abi_x86_32(-)]
			) )
			opencl? ( >=virtual/opencl-0-r3[abi_x86_32(-)] )
			opengl? ( || (
				app-emulation/emul-linux-x86-opengl[development,-abi_x86_32(-)]
				(
					>=virtual/glu-9.0-r1[abi_x86_32(-)]
					>=virtual/opengl-7.0-r1[abi_x86_32(-)]
				)
			) )
			gsm? ( || (
				app-emulation/emul-linux-x86-soundlibs[development,-abi_x86_32(-)]
				>=media-sound/gsm-1.0.13-r1[abi_x86_32(-)]
			) )
			jpeg? ( || (
				app-emulation/emul-linux-x86-baselibs[development,-abi_x86_32(-)]
				>=virtual/jpeg-0-r2:0[abi_x86_32(-)]
			) )
			ldap? ( || (
				app-emulation/emul-linux-x86-baselibs[development,-abi_x86_32(-)]
				>=net-nds/openldap-2.4.38-r1:=[abi_x86_32(-)]
			) )
			lcms? ( || (
				app-emulation/emul-linux-x86-baselibs[development,-abi_x86_32(-)]
				>=media-libs/lcms-2.5:2[abi_x86_32(-)]
			) )
			mp3? ( || (
				app-emulation/emul-linux-x86-soundlibs[development,-abi_x86_32(-)]
				>=media-sound/mpg123-1.15.4[abi_x86_32(-)]
			) )
			nls? ( || (
				app-emulation/emul-linux-x86-baselibs[development,-abi_x86_32(-)]
				>=sys-devel/gettext-0.18.3.2[abi_x86_32(-)]
			) )
			odbc? ( || (
				app-emulation/emul-linux-x86-db[development,-abi_x86_32(-)]
				>=dev-db/unixODBC-2.3.2:=[abi_x86_32(-)]
			) )
			xml? ( || (
				>=app-emulation/emul-linux-x86-baselibs-20131008[development,-abi_x86_32(-)]
				(
					>=dev-libs/libxml2-2.9.1-r4[abi_x86_32(-)]
					>=dev-libs/libxslt-1.1.28-r1[abi_x86_32(-)]
				)
			) )
			scanner? ( || (
				app-emulation/emul-linux-x86-medialibs[development,-abi_x86_32(-)]
				>=media-gfx/sane-backends-1.0.23:=[abi_x86_32(-)]
			) )
			ssl? ( || (
				app-emulation/emul-linux-x86-baselibs[development,-abi_x86_32(-)]
				>=net-libs/gnutls-2.12.23-r6:=[abi_x86_32(-)]
			) )
			png? ( || (
				app-emulation/emul-linux-x86-baselibs[development,-abi_x86_32(-)]
				>=media-libs/libpng-1.6.10:0[abi_x86_32(-)]
			) )
			v4l? ( || (
				app-emulation/emul-linux-x86-medialibs[development,-abi_x86_32(-)]
				>=media-libs/libv4l-0.9.5[abi_x86_32(-)]
			) )
			xcomposite? ( || (
				app-emulation/emul-linux-x86-xlibs[development,-abi_x86_32(-)]
				>=x11-libs/libXcomposite-0.4.4-r1[abi_x86_32(-)]
			) )
	>=sys-kernel/linux-headers-2.6
	)"
RDEPEND="truetype? ( >=media-libs/freetype-2.0.0 media-fonts/corefonts )
	perl? ( dev-lang/perl dev-perl/XML-Simple )
	capi? ( net-dialup/capi4k-utils )
	ncurses? ( >=sys-libs/ncurses-5.2 )
	fontconfig? ( media-libs/fontconfig )
	gphoto2? ( media-libs/libgphoto2 )
	openal? ( media-libs/openal )
	udisks? (
		sys-apps/dbus
		sys-fs/udisks:0
	)
	gnutls? ( net-libs/gnutls )
	gstreamer? ( media-libs/gstreamer media-libs/gst-plugins-base )
	X? (
		x11-libs/libXcursor
		x11-libs/libXrandr
		x11-libs/libXi
		x11-libs/libXmu
		x11-libs/libXxf86vm
		x11-apps/xmessage
	)
	xinerama? ( x11-libs/libXinerama )
	alsa? ( media-libs/alsa-lib )
	cups? ( net-print/cups )
	opencl? ( virtual/opencl )
	opengl? ( virtual/opengl )
	gsm? ( media-sound/gsm )
	jpeg? ( virtual/jpeg )
	ldap? ( net-nds/openldap )
	lcms? ( =media-libs/lcms-1* )
	mp3? ( >=media-sound/mpg123-1.5.0 )
	nls? ( sys-devel/gettext )
	odbc? ( dev-db/unixODBC )
	samba? ( >=net-fs/samba-3.0.25 )
	selinux? ( sec-policy/selinux-wine )
	xml? ( dev-libs/libxml2 dev-libs/libxslt )
	scanner? ( media-gfx/sane-backends )
	ssl? ( dev-libs/openssl )
	png? ( media-libs/libpng )
	v4l? ( media-libs/libv4l )
	!win64? ( ${MLIB_DEPS} )
	win32? ( ${MLIB_DEPS} )
	xcomposite? ( x11-libs/libXcomposite )"
DEPEND="${RDEPEND}
	X? (
		x11-proto/inputproto
		x11-proto/xextproto
		x11-proto/xf86vidmodeproto
	)
	xinerama? ( x11-proto/xineramaproto )
	!hardened? ( sys-devel/prelink )
	virtual/pkgconfig
	virtual/yacc
	sys-devel/flex"

src_unpack() {
	if use win64 ; then
		[[ $(( $(gcc-major-version) * 100 + $(gcc-minor-version) )) -lt 404 ]] \
			&& die "you need gcc-4.4+ to build 64bit wine"
	fi

	if use win32 && use opencl; then
		[[ x$(eselect opencl show) = "xintel" ]] &&
			die "Cannot build wine[opencl,win32]: intel-ocl-sdk is 64-bit only" # 403947
	fi

	if [[ ${PV} == "9999" ]] ; then
		git-2_src_unpack
	else
		unpack ${MY_P}.tar.bz2
	fi
}

src_prepare() {
	epatch "${FILESDIR}"/${PN}-1.1.15-winegcc.patch #260726
	epatch "${FILESDIR}"/${PN}-1.4_rc2-multilib-portage.patch #395615
	epatch ${FILESDIR}"/${PN}-ddraw.patch"
	epatch_user #282735
	eautoreconf
	sed -i '/^UPDATE_DESKTOP_DATABASE/s:=.*:=true:' tools/Makefile.in || die
	sed -i '/^MimeType/d' tools/wine.desktop || die #117785
}

do_configure() {
	local builddir="${WORKDIR}/wine$1"
	mkdir -p "${builddir}"
	pushd "${builddir}" >/dev/null

	ECONF_SOURCE=${S} \
	econf \
		--sysconfdir=/etc/wine \
		$(use_with alsa) \
		$(use_with capi) \
		$(use_with lcms cms) \
		$(use_with cups) \
		$(use_with ncurses curses) \
		$(use_with udisks dbus) \
		$(use_with fontconfig) \
		$(use_with gnutls) \
		$(use_with gphoto2 gphoto) \
		$(use_with gsm) \
		$(use_with gstreamer) \
		--without-hal \
		$(use_with jpeg) \
		$(use_with ldap) \
		$(use_with mp3 mpg123) \
		$(use_with nls gettext) \
		$(use_with openal) \
		$(use_with opencl) \
		$(use_with opengl) \
		$(use_with ssl openssl) \
		$(use_with oss) \
		$(use_with png) \
		$(use_with threads pthread) \
		$(use_with scanner sane) \
		$(use_enable test tests) \
		$(use_with truetype freetype) \
		$(use_with v4l) \
		$(use_with X x) \
		$(use_with xcomposite) \
		$(use_with xinerama) \
		$(use_with xml) \
		$(use_with xml xslt) \
		$2

	emake -j1 depend

	popd >/dev/null
}

src_configure() {
	export LDCONFIG=/bin/true
	use custom-cflags || strip-flags

	if use win64 ; then
		do_configure 64 --enable-win64
		use win32 && ABI=x86 do_configure 32 --with-wine64=../wine64
	else
		ABI=x86 do_configure 32 --disable-win64
	fi
}

src_compile() {
	local b
	for b in 64 32 ; do
		local builddir="${WORKDIR}/wine${b}"
		[[ -d ${builddir} ]] || continue
		emake -C "${builddir}" all
	done
}

src_install() {
	local b
	for b in 64 32 ; do
		local builddir="${WORKDIR}/wine${b}"
		[[ -d ${builddir} ]] || continue
		emake -C "${builddir}" install DESTDIR="${D}"
	done
	dodoc ANNOUNCE AUTHORS README
	if use gecko ; then
		insinto /usr/share/wine/gecko
		doins "${DISTDIR}"/wine_gecko-${GV}-x86.msi
		use win64 && doins "${DISTDIR}"/wine_gecko-${GV}-x86_64.msi
	fi
	if ! use perl ; then
		rm "${D}"usr/bin/{wine{dump,maker},function_grep.pl} "${D}"usr/share/man/man1/wine{dump,maker}.1 || die
	fi

	if use win32 || ! use win64; then
		pax-mark psmr "${D}"usr/bin/wine{,-preloader} #255055
	fi
	use win64 && pax-mark psmr "${D}"usr/bin/wine64{,-preloader}

	if use win64 && ! use win32; then
		dosym /usr/bin/wine{64,} # 404331
		dosym /usr/bin/wine{64,}-preloader
	fi
}
