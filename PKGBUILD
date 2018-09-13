# Maintainer: Wilson E. Alvarez <wilson.e.alvarez1@gmail.com>
# Contributor: p <parimal@beyond8labs.com>
# Contributor: Victor <victor@xirion.net>
# Contributor: Jan-Tarek Butt <tarek AT ring0 DOT de>
# Contributor: Erik Beran <eberan AT gmail DOT com>
# Contributor: Thor K. H. <thor at roht dot no>
# Contributor: Babken Vardanyan <483ken 4tgma1l
# Contributor: mikezackles
# Contributor: z33ky
# Contributor: stykr
# Contributor: Svenstaro
# Contributor: KaiSforza
# Contributor: Simon Gomizelj <simongmzlj@gmail.com>
# Contributor: Daniel Micay <danielmicay@gmail.com>
# Contributor: shmilee
# Contributor: foobster
# Contributor: archdria
# Contributor: Andy Weidenbaum <archbaum@gmail.com>
# Contributor: edacval



#=========================================================================================================#
#                                          Build Options                                                  #
#=========================================================================================================#
_omnisharp="y"
_gocode="y"
_rust="y"
_tern="y"
_java="y"
_use_system_clang="ON"

_neovim="$NEOVIM_YOUCOMPLETEME"
#=========================================================================================================#
#=========================================================================================================#



#=========================================================================================================#
#                                    Default PKGBUILD Configuration                                       #
#=========================================================================================================#
pkgname=vim-youcompleteme-git
pkgver=r2393.487b8ab2
pkgver() {
	cd "YouCompleteMe" || exit
	printf "r%s.%s" "$(git rev-list --count HEAD)" "$(git rev-parse --short HEAD)"
}
pkgrel=3
pkgdesc="A code-completion engine for Vim"
arch=('i686' 'x86_64')
url='http://valloric.github.com/YouCompleteMe/'
license=('GPL3')
groups=('vim-plugins')
depends=('boost' 'boost-libs' 'ncurses5-compat-libs' 'python' 'python2' 'nodejs' 'vim' 'clang')
makedepends=('cmake' 'git' 'make')
install=install.sh
source=(
'git+https://github.com/Valloric/YouCompleteMe.git' #ycm
'git+https://github.com/ross/requests-futures.git'  #ycm
'git+https://github.com/Valloric/ycmd.git'          #ycm
'git+https://github.com/kennethreitz/requests.git'  #ycmd
'git+https://github.com/bottlepy/bottle.git'        #ycmd
'git+https://github.com/slezica/python-frozendict.git'    #ycmd
'git+https://github.com/PythonCharmers/python-future.git' #ycmd
'git+https://github.com/davidhalter/jedi.git'             #jedi
'git+https://github.com/davidhalter/parso.git'            #jedi
'git+https://github.com/Pylons/waitress.git'              #ycmd,jediHTTP
'git+https://github.com/Manishearth/godef.git'            #ycmd
)
sha256sums=('SKIP' 'SKIP' 'SKIP' 'SKIP' 'SKIP' 'SKIP' 'SKIP' 'SKIP' 'SKIP' 'SKIP' 'SKIP')
#=========================================================================================================#
#=========================================================================================================#



#=========================================================================================================#
#                                     Applying PKBUILD Build Options                                      #
#=========================================================================================================#

if [[ "$_gocode" == "y" ]]; then
	# ycmd
	source+=('git+https://github.com/nsf/gocode.git')
	sha256sums+=('SKIP')
	makedepends+=('go')
fi


if [[ "$_omnisharp" == "y" ]]; then
	source+=( 'git+https://github.com/nosami/OmniSharpServer.git'       #ycmd
			 'git+https://github.com/icsharpcode/NRefactory.git'       #OmniSharpServer
			 'git+https://github.com/jbevain/cecil.git'                #OmniSharpServer
			)
	sha256sums+=('SKIP' 'SKIP' 'SKIP')
	depends+=('mono')
	makedepends+=('mono')
fi

if [[ "$_rust" == "y" ]]; then
	# ycmd
	source+=( 'git+https://github.com/jwilm/racerd.git')
	sha256sums+=('SKIP')
	depends+=('rust')
	makedepends+=('cargo')
fi

if [[ "$_tern" == "y" ]]; then
	# ycmd
	makedepends+=('npm')
fi

if [[ "$_java" == "y" ]]; then
	source+=("http://download.eclipse.org/jdtls/milestones/0.18.0/jdt-language-server-0.18.0-201805010001.tar.gz")
	sha256sums+=('9253d4222519442b65b4a01516c9496354b59813d906357a5f3f265601cc77db')
fi

#=========================================================================================================#
#=========================================================================================================#



#=========================================================================================================#
#                                           Utility Functions                                             #
#=========================================================================================================#

gitprepare() {
	local cd_dir=$1
	local git_prefix=$2
	local c=0
	for val in "$@" ; do
		if [ $c -gt 1 ]; then
			local feed[$c]=$val
		fi
		c=$(( c + 1 ))
	done

	cd "$srcdir/$cd_dir" || exit

	git submodule init
	for gitsubvar in "${feed[@]}" ; do
		git config submodule."$git_prefix$gitsubvar".url "$srcdir/$gitsubvar"
	done

	git submodule update
	unset -v feed
}
#=========================================================================================================#
#=========================================================================================================#



#=========================================================================================================#
#                                     Standard PKGBUILD Functions                                         #
#=========================================================================================================#


prepare() {
	msg2 'Setting up Git submodules...'

	local YouCompleteMe=("requests-futures" "ycmd")
	gitprepare "YouCompleteMe" "third_party/" "${YouCompleteMe[@]}"

	local ycmd=("bottle" "python-frozendict" "python-future" "waitress" "requests")

	if [[ "$_gocode" == "y" ]]; then
		ycmd+=("gocode" "godef")
	fi

	if [[ "$_omnisharp" == "y" ]]; then
		ycmd+=("OmniSharpServer")
	fi

	if [[ "$_rust" == "y" ]]; then
		ycmd+=("racerd")
	fi

	gitprepare "YouCompleteMe/third_party/ycmd" "third_party/" "${ycmd[@]}"

	local Jedi=("waitress" "jedi" "bottle" "parso")
	gitprepare "YouCompleteMe/third_party/ycmd/third_party/jedi" "vendor/" "${Jedi[@]}"

	if [[ "$_omnisharp" == "y" ]]; then
		local OmniSharpServer=("NRefactory" "cecil")
		gitprepare "YouCompleteMe/third_party/ycmd/third_party/OmniSharpServer" "" "${OmniSharpServer[@]}"
	fi
}


build() {

	#rm -rf $srcdir/YouCompleteMe/python/ycm/tests
	msg2 'Building ycmd...' # BuildYcmdLibs()
	mkdir -p "$srcdir/ycmd_build"
	cd "$srcdir/ycmd_build" || exit
	cmake -G "Unix Makefiles" -DUSE_SYSTEM_LIBCLANG="$_use_system_clang" . "$srcdir/YouCompleteMe/third_party/ycmd/cpp"
	make ycm_core

	if [[ "$_omnisharp" = "y" ]]; then
		msg2 'Building OmniSharp completer...' # BuildOmniSharp()
		cd "$srcdir/YouCompleteMe/third_party/ycmd/third_party/OmniSharpServer" || exit
		pwd
		xbuild /property:Configuration=Release
	else
		msg2 'Skipping OmniSharp completer...'
	fi

	if [[ "$_gocode" = "y" ]]; then
		msg2 'Building Gocode completer...' # BuildGoCode()
		cd "$srcdir/YouCompleteMe/third_party/ycmd/third_party/gocode" || exit
		pwd
		go build
		cd "$srcdir/YouCompleteMe/third_party/ycmd/third_party/godef" || exit
		pwd
		go build
	else
		msg2 'Skipping Gocode completer...'
	fi

	if [[ "$_rust" = "y" ]]; then
		msg2 'Building Rust completer...' # BuildRacerd()
		cd "$srcdir/YouCompleteMe/third_party/ycmd/third_party/racerd" || exit
		pwd
		cargo build --release
	else
		msg2 'Skipping Rust completer...'
	fi

	if [[ "$_tern" = "y" ]]; then
		msg2 'Building Tern completer...' # SetUpTern()
		cd "$srcdir/YouCompleteMe/third_party/ycmd/third_party/tern_runtime" || exit
		pwd
		npm install --production --python=python2
	else
		msg2 'Skipping Tern completer...'
	fi

	if [[ "$_java" = "y" ]]; then
		# Remove stale java completer data if any
		rm -rf "$srcdir/YouCompleteMe/third_party/ycmd/third_party/eclipse.jdt.ls/target/repository"
		mkdir -p "$srcdir/YouCompleteMe/third_party/ycmd/third_party/eclipse.jdt.ls/target/repository"
		mv "$srcdir"/{config_linux,features,plugins} "$srcdir/YouCompleteMe/third_party/ycmd/third_party/eclipse.jdt.ls/target/repository"
	fi
}


package() {

	local vimfiles_dir=usr/share/vim/vimfiles
	if [[ "$_neovim" == "y" ]]; then
		vimfiles_dir=usr/share/nvim/runtime
	fi

	mkdir -p "$pkgdir/$vimfiles_dir/third_party/ycmd/third_party"

	cp -r "$srcdir/YouCompleteMe/"{autoload,doc,plugin,python} \
		"$pkgdir/$vimfiles_dir"
	cp -r "$srcdir/YouCompleteMe/third_party/"{pythonfutures,requests-futures} \
		"$pkgdir/$vimfiles_dir/third_party"
	cp -r "$srcdir/YouCompleteMe/third_party/ycmd/"{ycmd,ycm_core.so,CORE_VERSION,cpp,clang_includes} \
		"$pkgdir/$vimfiles_dir/third_party/ycmd"
	cp -r "$srcdir/YouCompleteMe/third_party/ycmd/third_party/"{bottle,parso,frozendict,jedi,python-future,requests,waitress} \
		"$pkgdir/$vimfiles_dir/third_party/ycmd/third_party"

	if [[ "$_omnisharp" = "y" ]]; then
		mkdir -p "$pkgdir/$vimfiles_dir/third_party/ycmd/third_party/OmniSharpServer/OmniSharp/bin/Release"
		cp -r "$srcdir/YouCompleteMe/third_party/ycmd/third_party/OmniSharpServer/OmniSharp/bin/Release" \
			"$pkgdir/$vimfiles_dir/third_party/ycmd/third_party/OmniSharpServer/OmniSharp/bin"
	fi

	if [[ "$_gocode" = "y" ]]; then
		mkdir -p "$pkgdir/$vimfiles_dir/third_party/ycmd/third_party/gocode"
		mkdir -p "$pkgdir/$vimfiles_dir/third_party/ycmd/third_party/godef"
		cp    "$srcdir/YouCompleteMe/third_party/ycmd/third_party/gocode/gocode" \
			"$pkgdir/$vimfiles_dir/third_party/ycmd/third_party/gocode/gocode"
		cp    "$srcdir/YouCompleteMe/third_party/ycmd/third_party/godef/godef" \
			"$pkgdir/$vimfiles_dir/third_party/ycmd/third_party/godef/godef"
	fi

	if [[ "$_rust" = "y" ]]; then
		mkdir -p "$pkgdir/$vimfiles_dir/third_party/ycmd/third_party/racerd/target/release"
		cp    "$srcdir/YouCompleteMe/third_party/ycmd/third_party/racerd/target/release/racerd" \
			"$pkgdir/$vimfiles_dir/third_party/ycmd/third_party/racerd/target/release/racerd"
	fi

	if [[ "$_tern" = "y" ]]; then
		cp -r "$srcdir/YouCompleteMe/third_party/ycmd/third_party/tern_runtime" \
			"$pkgdir/$vimfiles_dir/third_party/ycmd/third_party"
	fi

	if [[ "$_java" = "y" ]]; then
		mv "$srcdir/YouCompleteMe/third_party/ycmd/third_party/eclipse.jdt.ls" "$pkgdir/$vimfiles_dir/third_party/ycmd/third_party"
		# Force the java completion engine to create its workspace at /tmp instead which is writeable by every user
		ln -sf /tmp "$pkgdir/$vimfiles_dir/third_party/ycmd/third_party/eclipse.jdt.ls/workspace"
	fi

	find "$pkgdir" -name .git -exec rm -fr {} +
	rm -rf "$pkgdir/$vimfiles_dir/third_party/ycmd/ycmd/tests"

}

#=========================================================================================================#
#=========================================================================================================#
