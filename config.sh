# SPDX-FileCopyrightText: 2021 René de Hesselle <dehesselle@web.de>
#
# SPDX-License-Identifier: GPL-2.0-or-later

### description ################################################################

# Abstraction and convenience layer ontop of backends ini.sh and plist.sh.

### shellcheck #################################################################

# shellcheck shell=bash # no shebang as this file is intended to be sourced

### dependencies ###############################################################

bash_d_include echo
bash_d_include xdg

if [ "$(uname)" = "Darwin" ]; then
  bash_d_include plist
else
  bash_d_include ini
fi

### variables ##################################################################

if [ -z "$CONFIG_DIR" ]; then
  CONFIG_DIR=
fi

if [ -z "$CONFIG_FILE" ]; then
  CONFIG_FILE=
fi

### functions ##################################################################

function config_value
{
  local value=$1
  local value_default=$2

  if [ -n "$value" ]; then
    echo "$value"
  else
    echo "$value_default"
  fi
}

function config_get_dir
{
  local dir

  dir=$XDG_CONFIG_HOME
  if [ ! -w "$dir" ]; then
    dir=$(dirname "$0")
    if [ ! -w "$dir" ]; then
      dir=$(config_value "$TMP" "/tmp")
      echo_w "using $dir as CONFIG_DIR"
    fi
  fi

  echo "$dir"
}

function config_get_file
{
  local file
  if bash_d_is_included plist; then
    file=$(basename -s .sh "$0").plist
  else
    file=$(basename -s .sh "$0").ini
  fi

  file=$XDG_CONFIG_HOME/$file
  if [ ! -f "$file" ]; then
    file=$(dirname "$0")/$file
    if [ ! -f "$file" ]; then
      basename "$file"
      return 1
    fi
  fi

  echo "$file"
}

function config_instantiate
{
  local file=$1
  local name=$2

  if bash_d_is_included plist; then
    alias config_${name}_del="plist_del__ $file"
    alias config_${name}_get="plist_get__ $file"
    alias config_${name}_set="plist_set__ $file"
  else
    alias config_${name}_del="ini_del__ $file"
    alias config_${name}_get="ini_get__ $file"
    alias config_${name}_set="ini_set__ $file"
  fi
}

### aliases ####################################################################

if bash_d_is_included plist; then
  alias config_del='plist_del $CONFIG_FILE'
  alias config_get='plist_get $CONFIG_FILE'
  alias config_set='plist_set $CONFIG_FILE'
else
  alias config_del='ini_del $CONFIG_FILE'
  alias config_get='ini_get $CONFIG_FILE'
  alias config_set='ini_set $CONFIG_FILE'
fi

### main #######################################################################

if [ -z "$CONFIG_FILE" ]; then
  if ! CONFIG_FILE=$(config_get_file); then
    CONFIG_DIR=$(config_get_dir)
    CONFIG_FILE=$CONFIG_DIR/$CONFIG_FILE
  fi
fi
