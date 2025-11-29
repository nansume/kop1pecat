# Copyright 1999-2025 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( lua5-4 luajit )

inherit flag-o-matic lua-single git-r3

DESCRIPTION="Simple pastecat service for your own self-hosting."
HOMEPAGE="https://github.com/nansume/kop1pecat"
#EGIT_REPO_URI="https://github.com/nansume/kop1pecat"
SRC_URI="https://github.com/nansume/kop1pecat/archive/master.tar.gz -> ${P}.tar.gz"

LICENSE="UnLicense"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="bytecode"

RDEPEND="${LUA_DEPS}"


src_compile() {
	emake -f Makefile PREFIX="/" compile || die "emake error"
}

src_install() {
	emake DESTDIR="${D}" install-strip
}