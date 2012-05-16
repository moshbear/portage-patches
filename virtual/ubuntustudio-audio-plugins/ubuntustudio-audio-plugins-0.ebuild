# Copyright 2011 m0shbear
# Distributed under the terms of the GNU General Public License v2

EAPI="2"

DESCRIPTION="A collection of LADSPA, LV2, and DSSI plugins."
HOMEPAGE="http://www.moshbear.net/ubuntustudio-for-gentoo"
SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
IUSE="ubuntustudio_force-missing-keywords ubuntustudio_has-aeolus"

RDEPEND="
media-libs/fluidsynth-dssi
media-libs/ladspa-cmt
media-libs/rubberband
media-plugins/blop
media-plugins/calf
media-plugins/caps-plugins
media-plugins/hexter
ubuntustudio_force-missing-keywords? ( media-plugins/lv2fil )
media-plugins/mcp-plugins
media-plugins/swh-lv2
media-plugins/tap-plugins
media-plugins/vocproc
media-plugins/xsynth-dssi
ubuntustudio_has-aeolus? ( media-sound/aeolus )
"
