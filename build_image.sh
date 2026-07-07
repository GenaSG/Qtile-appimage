#!/bin/sh

set -xu
ARCH=x86_64
APP=qtile
APPDIR="${APP}.AppDir"
APPDIR_BIN="${APPDIR}/usr/bin"
APPDIR_ENV="${APPDIR}/env"
which python3 || exit 1
which pip3 || exit 1
which rofi || exit 1

PYTHON_BIN=$(which python3)
PIP_BIN=$(which pip3)
ROFI_BIN=$(which rofi)


ROFI_POWER_MENU="https://raw.githubusercontent.com/jluttine/rofi-power-menu/refs/tags/3.1.0/rofi-power-menu"
LINUXDEPLOY="https://github.com/linuxdeploy/linuxdeploy/releases/download/continuous/linuxdeploy-x86_64.AppImage"
APPIMAGETOOL="https://github.com/pkgforge-dev/appimagetool-uruntime/releases/download/continuous/appimagetool-x86_64.AppImage"

#DOWNLOAD TOOLS
if [ ! -f ./linuxdeploy-x86_64.AppImage ]; then 
       	wget $LINUXDEPLOY && chmod u+x  ./linuxdeploy-x86_64.AppImage || exit 1
fi

if [ ! -f ./appimagetool-x86_64.AppImage ]; then
	wget $APPIMAGETOOL && chmod u+x  ./appimagetool-x86_64.AppImage || exit 1
fi

#PREPARE DIR
[ -d ./${APPDIR} ] && rm -rf ./${APPDIR}
[ ! -d ./${APPDIR} ] && mkdir -p ./${APPDIR_BIN}
cp -r ./config ./${APPDIR}/

#ADD ROFI
cp $ROFI_BIN ./${APPDIR_BIN}/rofi
wget ${ROFI_POWER_MENU} -o ./${APPDIR_BIN}/rofi-power-menu
chmod +x ./${APPDIR_BIN}/rofi-power-menu
#ADD PYTHON BIN
cp $PYTHON_BIN ./${APPDIR_BIN}/python


#PREPARE APPDIR
./linuxdeploy-x86_64.AppImage --appdir=./${APPDIR} --executable=./${APPDIR_BIN}/python --desktop-file=./${APP}.desktop --icon-file=./${APP}.png --custom-apprun=./AppRun || exit 1

./linuxdeploy-x86_64.AppImage --appdir=./${APPDIR} --executable=./${APPDIR_BIN}/rofi --desktop-file=./${APP}.desktop --icon-file=./${APP}.png --custom-apprun=./AppRun || exit 1

$PIP_BIN install --upgrade --target ${APPDIR}/qtile qtile

#BUILD IMAGE
./appimagetool-x86_64.AppImage ./${APPDIR}
