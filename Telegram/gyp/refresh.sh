#!/usr/bin/env bash
set -e
FullExecPath=$PWD
pushd `dirname $0` > /dev/null
FullScriptPath=`pwd`
popd > /dev/null

if [ -f "$FullScriptPath/../build/target" ]; then
  while IFS='' read -r line || [[ -n "$line" ]]; do
    BuildTarget="$line"
  done < "$FullScriptPath/../build/target"
else
  BuildTarget=""
fi

MySystem=`uname -s`
cd $FullScriptPath

if [ "$MySystem" == "Linux" ]; then
  ../../../Libraries/gyp/gyp --depth=. --generator-output=.. -Goutput_dir=../out -Dofficial_build_target=$BuildTarget Telegreat.gyp --format=cmake
  cd ../../out/Debug
  cmake .
  cd ../Release
  cmake .
  cd ../../Telegram/gyp
else
  #gyp --depth=. --generator-output=../.. -Goutput_dir=out Telegram.gyp --format=ninja
  #gyp --depth=. --generator-output=../.. -Goutput_dir=out Telegram.gyp --format=xcode-ninja
  #gyp --depth=. --generator-output=../.. -Goutput_dir=out Telegram.gyp --format=xcode
  # use patched gyp with Xcode project generator
  ../../../Libraries/gyp/gyp --depth=. --generator-output=.. -Goutput_dir=../out -Gxcode_upgrade_check_project_version=930 -Dofficial_build_target=$BuildTarget Telegreat.gyp --format=xcode
fi

cd ../..

cd $FullExecPath
exit

