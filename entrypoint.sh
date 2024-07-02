#!/usr/bin/env bash

set -eu

export GITHUB="true"

[ -n "$*" ] && export TELEGRAM_MESSAGE="$*"

echo "Detecting operating system ..."
case "$OSTYPE" in
  darwin*)  echo "Detected operating system: macOS"; PLATFORM="macOS" ;; 
  linux*)   echo "Detected operating system: Linux"; PLATFORM="Linux" ;;
  msys*|cygwin*|win32*) echo "Detected operating system: Windows"; PLATFORM="Windows" ;;
  *)        echo "Unsupported operating system: $OSTYPE"; exit 1 ;;
esac
echo

echo "Downloading or building drone-telegram for $PLATFORM ..."
if [[ $PLATFORM == 'macOS' ]]; then
  DRONE_TELEGRAM_DOWNLOAD_URL="https://github.com/appleboy/drone-telegram/releases/download/v1.3.10/drone-telegram-v1.3.10-darwin-amd64"
elif [[ $PLATFORM == 'Linux' ]]; then
  DRONE_TELEGRAM_DOWNLOAD_URL="https://github.com/appleboy/drone-telegram/releases/download/v1.3.10/drone-telegram-v1.3.10-linux-amd64"
elif [[ $PLATFORM == 'Windows' ]]; then
  # Check if the binary is available, else build from source
  DRONE_TELEGRAM_DOWNLOAD_URL=""
  if curl --output /dev/null --silent --head --fail "https://github.com/appleboy/drone-telegram/releases/download/v1.3.10/drone-telegram-v1.3.10-windows-amd64.exe"; then
    DRONE_TELEGRAM_DOWNLOAD_URL="https://github.com/appleboy/drone-telegram/releases/download/v1.3.10/drone-telegram-v1.3.10-windows-amd64.exe"
  else
    echo "Windows binary not found. Building from source..."
    go install github.com/appleboy/drone-telegram@latest
    mv $(go env GOPATH)/bin/drone-telegram.exe $GITHUB_ACTION_PATH/drone-telegram.exe
  fi
fi

if [[ -n $DRONE_TELEGRAM_DOWNLOAD_URL ]]; then
  curl -L $DRONE_TELEGRAM_DOWNLOAD_URL -o $GITHUB_ACTION_PATH/drone-telegram
  chmod +x $GITHUB_ACTION_PATH/drone-telegram
fi

echo "Launching drone-telegram ..."
if [[ $PLATFORM == 'Windows' ]]; then
  exec $GITHUB_ACTION_PATH/drone-telegram.exe
else
  exec $GITHUB_ACTION_PATH/drone-telegram
fi
