#!/bin/sh

set -eu

ARCH=$(uname -m)

echo "Installing package dependencies..."
echo "---------------------------------------------------------------"
pacman -Syu --noconfirm \
	cmake         \
	fmt           \
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
get-debloated-pkgs --add-common --prefer-nano libdecor-mini

make-aur-package zenity-rs-bin

echo "Making stable build of 2ship2harkinian..."
echo "---------------------------------------------------------------"
REPO=https://github.com/HarbourMasters/2ship2harkinian
VERSION=$(git ls-remote --tags --refs --sort=-v:refname "$REPO" | awk -F'/' '{print $NF; exit}')

git clone --branch "$VERSION" --single-branch --recursive --depth 1 "$REPO" ./2s2h && (
	cd ./2s2h

	cmake ./ -Bbuild -GNinja
	cmake --build build --config Release -j$(nproc)
	cmake --build build --config Release --target Generate2ShipOtr -j$(nproc)

	echo "$VERSION" > ~/version
)

mkdir -p ./AppDir/bin
mv -v ./2s2h/build/mm/assets ./2s2h/build/mm/2s2h.elf ./2s2h/build/mm/2ship.o2r ./AppDir/bin
wget -O ./AppDir/bin/gamecontrollerdb.txt https://raw.githubusercontent.com/mdqinc/SDL_GameControllerDB/master/gamecontrollerdb.txt

