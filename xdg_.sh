# SPDX-License-Identifier: GPL-2.0-or-later
# https://github.com/dehesselle/bash_d

include_guard

### description ################################################################

# XDG Base Directory Specification
# https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html

### includes ###################################################################

# Nothing here.

### variables ##################################################################

if [ -z $XDG_CONFIG_HOME ]; then
  export XDG_CONFIG_HOME=$HOME/.config
fi

if [ -z $XDG_CACHE_HOME ]; then
  export XDG_CACHE_HOME=$HOME/.cache
fi

if [ -z $XDG_DATA_HOME ]; then
  export XDG_DATA_HOME=$HOME/.local/share
fi

if [ -z $XDG_RUNTIME_DIR ]; then
  # This is a bad choice as it does not have properties that the spec requries
  # (user-owned, 700 permission, guaranteed creation/destruction on
  # login/logout), but I have nothing better to offer.
  export XDG_RUNTIME_DIR=$HOME/.local/run
fi

### functions ##################################################################

function xdg_create_dirs
{
  if [ ! -d "$XDG_CONFIG_HOME" ]; then
    mkdir -p "$XDG_CONFIG_HOME"
  fi

  if [ ! -d "$XDG_CACHE_HOME" ]; then
    mkdir -p "$XDG_CACHE_HOME"
  fi

  if [ ! -d "$XDG_DATA_HOME" ]; then
    mkdir -p "$XDG_DATA_HOME"
  fi

  if [ ! -d "$XDG_RUNTIME_DIR" ]; then
    mkdir -p "$XDG_RUNTIME_DIR"
  fi
}

### aliases ####################################################################

# Nothing here.

### main #######################################################################

# Nothing here.