# Copyright 2011 m0shbear

EAPI="2"

DESCRIPTION="A collection of applications aimed at recording and editing audio."
HOMEPAGE="http://www.moshbear.net/ubuntustudio-for-gentoo"
SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"

RDEPEND="
app-cdr/cdrdao[gtkmaster]
media-libs/hydrogen-drumkits
media-libs/libffado[qt4]
media-plugins/audacious-plugins
media-sound/alsa-tools[fltk,gtk]
media-sound/ardour
media-sound/audacious
media-sound/guitarix
media-sound/hydrogen
media-sound/jack-audio-connection-kit[-dbus]
media-sound/jack-rack
media-sound/jamin
media-sound/jamin-presets
media-sound/lash
media-sound/meterbridge
media-sound/patchage
media-sound/qjackctl
media-sound/rakarrack
media-sound/zynjacku
sys-process/rtirq
"
