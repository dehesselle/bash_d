# SPDX-FileCopyrightText: 2021 René de Hesselle <dehesselle@web.de>
#
# SPDX-License-Identifier: GPL-2.0-or-later

### description ################################################################

# XDG Base Directory Specification
# https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html
#
# You can either access the variables directly or use the helper-functions
# 'xdg_get_xxx' that make sure the directories exist.

### shellcheck #################################################################

# shellcheck shell=bash # no shebang as this file is intended to be sourced

### includes ###################################################################

include_guard

### variables ##################################################################

if [ -z "$XDG_CONFIG_HOME" ]; then
  export XDG_CONFIG_HOME=$HOME/.config
fi

if [ -z "$XDG_CACHE_HOME" ]; then
  export XDG_CACHE_HOME=$HOME/.cache
fi

if [ -z "$XDG_DATA_HOME" ]; then
  export XDG_DATA_HOME=$HOME/.local/share
fi

if [ -z "$XDG_RUNTIME_DIR" ]; then
  # This is a bad choice as it does not have properties that the spec requries
  # (user-owned, 700 permission, guaranteed creation/destruction on
  # login/logout), but I have nothing better to offer.
  export XDG_RUNTIME_DIR=$HOME/.local/run
fi

### functions ##################################################################

function xdg_get
{
  local var=$1

  local dir
  eval dir="\$$var"

  # XDG directories are expected to be created if they don't exist.
  if [ ! -d "$dir" ]; then
    mkdir -p "$dir"
  fi

  echo "$dir"
}

function xdg_get_config_home
{
  xdg_get XDG_CONFIG_HOME
}

function xdg_get_cache_home
{
  xdg_get XDG_CACHE_HOME
}

function xdg_get_data_home
{
  xdg_get XDG_DATA_HOME
}

function xdg_get_runtime_dir
{
  xdg_get XDG_RUNTIME_DIR
}

### aliases ####################################################################

# Nothing here.

### main #######################################################################

# Nothing here.