#!/bin/sh

set -eu

ARCH=$(uname -m)

echo "Installing package dependencies..."
echo "---------------------------------------------------------------"
pacman -Syu --noconfirm \
    cmake         \
    fmt           \
    libdecor      \
    libzip        \
    lsb-release   \
    ninja         \
    nlohmann-json \
    opusfile      \
    python        \
    sdl2          \
    sdl2_net      \
    spdlog        \
    tinyxml2

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common --prefer-nano

make-aur-package zenity-rs-bin

echo "Making stable build of 2ship2harkinian..."
echo "---------------------------------------------------------------"
REPO="https://github.com/HarbourMasters/2ship2harkinian"
VERSION="$(git ls-remote --tags --sort="v:refname" "$REPO" | tail -n1 | sed 's/.*\///; s/\^{}//')"
git clone --branch "$VERSION" --single-branch --recursive --depth 1 "$REPO" ./2ship2harkinian
echo "$VERSION" > ~/version

mkdir -p ./AppDir/bin/lib
cd ./2ship2harkinian
cmake . \
    -Bbuild \
    -GNinja
cmake --build build --config Release
cmake --build build --config Release --target Generate2ShipOtr

mv -v build/mm/assets ../AppDir/bin
mv -v build/mm/2s2h.elf ../AppDir/bin
mv -v build/mm/2ship.o2r ../AppDir/bin
mv -v build/_deps/stormlib-build/libstorm.a ../AppDir/bin/lib
wget -O ../AppDir/bin/gamecontrollerdb.txt https://raw.githubusercontent.com/mdqinc/SDL_GameControllerDB/master/gamecontrollerdb.txt
cp -v build/2s2hIcon.png ../AppDir/.DirIcon
mv -v build/2s2hIcon.png ../AppDir/2s2h.png
