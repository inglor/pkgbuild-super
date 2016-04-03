# Maintainer: Leonidas Spyropoulos <artafinde at gmail dot com>

### BUILD OPTIONS
# Set these variables to ANYTHING that is not null to enable them

# Use the archive without the bundled JDK - make sure you use your own,
# either through JAVA_HOME or by setting the path to the JDK
# in ~/.IntelliJIdea2016.1/config/idea.jdk
_use_no_jdk_archive=

### Do no edit below this line unless you know what you're doing

pkgname=intellij-idea-ce-eap
_pkgname=idea-IC
_buildver=145.597.3
_veryear=2016
_verrelease=1
_verextra=1
_nojdkrelease=false
pkgver=${_veryear}.${_verrelease}.${_buildver}
pkgrel=1
pkgdesc="Early access version of the upcoming version of Intellij Idea IDE (community version)"
arch=('any')
options=(!strip)
url="http://www.jetbrains.com/idea/"
license=('Apache2')
depends=('java-environment' 'giflib' 'libxtst')
makedepends=('wget')
if [ ${_nojdkrelease} = "true" ] && [ -n ${_use_no_jdk_archive} ]; then
  source=("https://download.jetbrains.com/idea/ideaIC-${_veryear}.${_verrelease}.${_verextra}-no-jdk.tar.gz")
  sha256sums=($(wget -q "${source}.sha256" && cat "ideaIC-${_veryear}.${_verrelease}.${_verextra}-no-jdk.tar.gz.sha256" | cut -f1 -d" "))
else
  source=("https://download.jetbrains.com/idea/ideaIC-${_veryear}.${_verrelease}.${_verextra}.tar.gz")
  sha256sums=($(wget -q "${source}.sha256" && cat "ideaIC-${_veryear}.${_verrelease}.${_verextra}.tar.gz.sha256" | cut -f1 -d" "))
fi

package() {
    cd "$srcdir"
    mkdir -p "${pkgdir}/opt/${pkgname}"
    cp -R "${srcdir}/idea-IC-${_buildver}/"* "${pkgdir}/opt/${pkgname}"
    if [[ $CARCH = 'i686' ]]; then
        rm -f "${pkgdir}/opt/${pkgname}/bin/libyjpagent-linux64.so"
        rm -f "${pkgdir}/opt/${pkgname}/bin/fsnotifier64"
    fi
    if [ ${_nojdkrelease} = "false" ] && [ -n ${_use_no_jdk_archive} ]; then
      rm -rf "${pkgdir}/opt/${pkgname}/jre"
    fi
(
cat <<EOF
[Desktop Entry]
Version=$pkgver
Type=Application
Name=IntelliJ IDEA Community EAP
Comment=Intelligent Java IDE - EAP version
Exec="/opt/$pkgname/bin/idea.sh" %f
Icon=/opt/$pkgname/bin/idea.png
Comment=$pkgdesc
Categories=Development;IDE;
Terminal=false
StartupNotify=true
StartupWMClass=jetbrains-idea
EOF
) > "${srcdir}/${pkgname}.desktop"

    mkdir -p "${pkgdir}/usr/bin/"
    mkdir -p "${pkgdir}/usr/share/applications/"
    mkdir -p "${pkgdir}/usr/share/licenses/${pkgname}/"
    install -Dm644 "${srcdir}/${pkgname}.desktop" "${pkgdir}/usr/share/applications/"
    for i in $(ls $srcdir/idea-IC-$_buildver/license/ ); do
      ln -sf "${srcdir}/idea-IC-${_buildver}/license/$i" "${pkgdir}/usr/share/licenses/${pkgname}/$i"
    done
    ln -s "/opt/${pkgname}/bin/idea.sh" "${pkgdir}/usr/bin/idea-ce-eap"
}

# vim:set ts=2 sw=2 et:
