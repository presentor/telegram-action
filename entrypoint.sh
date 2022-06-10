#!/usr/bin/env bash

set -eu

export GITHUB="true"

[ -n "$*" ] && export TELEGRAM_MESSAGE="$*"

$GITHUB_ACTION_PATH/drone-telegram
# ./drone-telegram
