#!/usr/bin/env bash

set -eu

export GITHUB="true"

[ -n "$*" ] && export TELEGRAM_MESSAGE="$*"

./drone-telegram
