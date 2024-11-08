#!/bin/bash

#Sourced from https://www.ogre3d.org/download/sdk/sdk-ogre-next
# Quick Start scripts for Ogre 3.0

OGRE_BRANCH_NAME="v3-0"

mkdir Ogre
cd Ogre
if test ! -d ogre-next-deps; then
	mkdir ogre-next-deps
	echo "--- Cloning ogre-next-deps ---"
	git clone --recurse-submodules --shallow-submodules https://github.com/OGRECave/ogre-next-deps || exit $?
else
	echo "--- ogre-next-deps repo detected. Cloning skipped ---"
fi
cd ogre-next-deps
mkdir build
cd build
echo "--- Building ogre-next-deps ---"
cmake  -G Ninja .. || exit $?
ninja || exit $?
ninja install || exit $?

cd ../../
if test ! -d ogre-next; then
	mkdir ogre-next
	echo "--- Cloning Ogre-Next v3-0 ---"
	git clone --branch ${OGRE_BRANCH_NAME} https://github.com/OGRECave/ogre-next || exit $?
fi
cd ogre-next
if test ! -L Dependencies; then
	ln -s ../ogre-next-deps/build/ogredeps Dependencies
fi
mkdir -p build/Debug
mkdir -p build/Release
cd build/Debug
echo "--- Building Ogre (Debug) ---"
cmake -D OGRE_CONFIG_THREAD_PROVIDER=0 -D OGRE_CONFIG_THREADS=0 -D OGRE_BUILD_COMPONENT_SCENE_FORMAT=1 -D OGRE_BUILD_SAMPLES2=1 -D OGRE_BUILD_TESTS=1 -D CMAKE_BUILD_TYPE="Debug"  -G Ninja ../.. || exit $?
ninja || exit $?
cd ../Release
echo "--- Building Ogre (Release) ---"
cmake -D OGRE_CONFIG_THREAD_PROVIDER=0 -D OGRE_CONFIG_THREADS=0 -D OGRE_BUILD_COMPONENT_SCENE_FORMAT=1 -D OGRE_BUILD_SAMPLES2=1 -D OGRE_BUILD_TESTS=1 -D CMAKE_BUILD_TYPE="Release"  -G Ninja ../.. || exit $?
ninja || exit $?

echo "Done!"
