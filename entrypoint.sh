#!/usr/bin/env bash

set -eu

# TODO: Disable these, obviously!
set -x
printenv

export GITHUB="true"

[ -n "$*" ] && export TELEGRAM_MESSAGE="$*"

exec $GITHUB_ACTION_PATH/drone-telegram
# ./drone-telegram
