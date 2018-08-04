# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_{5,6} )
DISTUTILS_SINGLE_IMPL=1

inherit distutils-r1 gnome2-utils

DESCRIPTION="Metadata Anonymisation Toolkit"
HOMEPAGE="https://mat.boum.org/ https://0xacab.org/jvoisin/mat2"
SRC_URI="https://0xacab.org/jvoisin/mat2/-/archive/${PV}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+audio +image nautilus +pdf"

DEPEND="dev-python/python-distutils-extra[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}
	audio? ( media-libs/mutagen[${PYTHON_USEDEP}] )
	image? ( x11-libs/gdk-pixbuf[introspection] )
	pdf? ( dev-python/pycairo[${PYTHON_USEDEP}]
		app-text/poppler[introspection] )
	nautilus? ( dev-python/nautilus-python[${PYTHON_USEDEP}] )
	dev-python/pygobject[${PYTHON_USEDEP}]
	media-libs/exiftool"

DOCS=( README.md doc/implementation_notes.md doc/threat_model.md )
PATCHES=( ${FILESDIR}/mat2-0.3.1_failing_test.patch )

python_test() {
	"${EPYTHON}" -m unittest discover -v || die "Tests fail with ${EPYTHON}"
}

python_install_all() {
	distutils-r1_python_install_all

	newman doc/mat.1 mat2.1
	doicon data/mat2.png # 1,920px × 2,783px
	doicon -s scalable data/mat2.svg

	insinto /usr/share/nautilus-python/extensions/
	doins nautilus/mat2.py
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
