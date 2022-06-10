#!/usr/bin/env bash

set -eu

export GITHUB="true"

[ -n "$*" ] && export TELEGRAM_MESSAGE="$*"

# TODO: Disable these, obviously!
set -x
printenv

# echo "Switching working directory to action root ..."
# cd $GITHUB_ACTION_PATH

echo "Detecting operating system ..."
# PLATFORM=""
case "$OSTYPE" in
  # solaris*) echo "SOLARIS" ;;
  darwin*)  echo "Detected operating system: macOS"; PLATFORM="macOS" ;; 
  linux*)   echo "Detected operating system: Linux"; PLATFORM="Linux" ;;
  # bsd*)     echo "BSD" ;;
  # msys*)    echo "WINDOWS" ;;
  # cygwin*)  echo "ALSO WINDOWS" ;;
  *)        echo "Unsupported operating system: $OSTYPE"; exit 1 ;;
esac
echo

echo "Downloading drone-telegram for $PLATFORM ..."
# DRONE_TELEGRAM_DOWNLOAD_URL=""
if [[ $PLATFORM == 'macOS' ]]; then
  DRONE_TELEGRAM_DOWNLOAD_URL="https://github.com/appleboy/drone-telegram/releases/download/v1.3.10/drone-telegram-v1.3.10-darwin-amd64"
elif [[ $PLATFORM == 'Linux' ]]; then
  DRONE_TELEGRAM_DOWNLOAD_URL="https://github.com/appleboy/drone-telegram/releases/download/v1.3.10/drone-telegram-v1.3.10-linux-amd64"
else
  echo "Unsupported PLATFORM: $PLATFORM"
  exit 1
fi
curl -L $DRONE_TELEGRAM_DOWNLOAD_URL -o $GITHUB_ACTION_PATH/drone-telegram
chmod +x $GITHUB_ACTION_PATH/drone-telegram

echo "Launching drone-telegram ..."
pwd
ls -lah . $GITHUB_ACTION_PATH
# ./entrypoint.sh
# printenv
# exec $GITHUB_ACTION_PATH/entrypoint.sh

exec $GITHUB_ACTION_PATH/drone-telegram
# ./drone-telegram
