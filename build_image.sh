#!/bin/sh

set -xu
ARCH=x86_64
APP=qtile
APPDIR="${APP}.AppDir"
APPDIR_BIN="${APPDIR}/usr/bin"
APPDIR_ENV="${APPDIR}/env"
which python3 || exit 1
PYTHON_BIN=$(which python3)

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

#PREPARE APPDIR
cp $PYTHON_BIN ./${APPDIR_BIN}/python
./linuxdeploy-x86_64.AppImage --appdir=./${APPDIR} --executable=./${APPDIR_BIN}/python --desktop-file=./${APP}.desktop --icon-file=./${APP}.png --custom-apprun=./AppRun || exit 1

bash -xc "${APPDIR_BIN}/python -m venv ./${APPDIR_ENV} && source ./${APPDIR_ENV}/bin/activate && ${APPDIR_ENV}/bin/pip install qtile || exit 1" || exit 1

#BUILD IMAGE
./appimagetool-x86_64.AppImage ./${APPDIR}
