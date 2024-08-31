#!/usr/bin/env bash
set -e

export RESET='\033[0m'

export DARK_RED='\033[31m'
export DARK_GREEN='\033[32m'
export DARK_YELLOW='\033[33m'
export DARK_BLUE='\033[34m'
export DARK_MAGENTA='\033[35m'
export DARK_CYAN='\033[36m'

export RED='\033[91m'
export GREEN='\033[92m'
export YELLOW='\033[93m'
export BLUE='\033[94m'
export MAGENTA='\033[95m'
export CYAN='\033[96m'
export WHITE='\033[97m'
export GRAY='\033[37m'

if [ ! -z "$TEAMCITY_VERSION" ]; then
  export DARK_THEME=1
fi

if [ ! -z "$CI" ]; then
  export DARK_THEME=1
fi

if [ ! -z "$DARK_THEME" ]; then
  export RED="$DARK_RED"
  export GREEN="$DARK_GREEN"
  export YELLOW="$DARK_YELLOW"
  export BLUE="$DARK_BLUE"
  export MAGENTA="$DARK_MAGENTA"
  export CYAN="$DARK_CYAN"
  export WHITE="$GRAY"
fi
