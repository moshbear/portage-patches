# Copyright 2011 m0shbear

EAPI="2"

DESCRIPTION="A collection of applications aimed at tone generation and editing."
HOMEPAGE="http://www.moshbear.net/ubuntustudio-for-gentoo"
SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"

RDEPEND="
app-cdr/cdrdao[gcdmaster]
media-libs/hydrogen-drumkits
media-libs/hydrogen-drumkits
media-libs/libffado[qt4]
media-plugins/audacious-plugins
media-plugins/whysynth
media-sound/alsa-tools[fltk,gtk]
media-sound/ardour
media-sound/audacious
media-sound/fluidsynth
media-sound/hydrogen
media-sound/jack-audio-connection-kit[-dbus]
media-sound/jack-rack
media-sound/lash
media-sound/meterbridge
media-sound/musescore
media-sound/patchage
media-sound/phasex
media-sound/qjackctl
media-sound/qsynth
media-sound/qtractor
media-sound/rakarrack
media-sound/sooperlooper
media-sound/specimen
media-sound/vkeybd
media-sound/yoshimi
media-sound/zynjacku
puredata-base/pd-extended
sys-apps/jackd-init
sys-process/rtirq
"
