# SPDX-FileCopyrightText: 2021 René de Hesselle <dehesselle@web.de>
#
# SPDX-License-Identifier: GPL-2.0-or-later

### description ################################################################

# Abstraction ontop of backends like ini.sh or plist.sh.

### shellcheck #################################################################

# shellcheck shell=bash # no shebang as this file is intended to be sourced

### dependencies ###############################################################

bash_d_include_guard
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
  file=$(basename -s .sh "$0").$CONFIG_FILE_SUFFIX

  file=$XDG_CONFIG_HOME/$file
  if [ ! -f "$file" ]; then
    file=$(dirname "$0")/$(basename "$file")
    if [ ! -f "$file" ]; then
      basename "$file"
      return 1
    fi
  fi

  echo "$file"
}

### aliases ####################################################################

# See main section.

### main #######################################################################

if [ "$(uname)" = "Darwin" ]; then
  alias config_get='plist_get'
  alias config_set='plist_set'
  CONFIG_FILE_SUFFIX=plist
else
  alias config_get='ini_get'
  alias config_set='ini_set'
  CONFIG_FILE_SUFFIX=ini
fi

if [ -z "$CONFIG_FILE" ]; then
  if ! CONFIG_FILE=$(config_get_file); then
    CONFIG_DIR=$(config_get_dir)
    CONFIG_FILE=$CONFIG_DIR/$CONFIG_FILE
  fi
fi

if [ "$CONFIG_FILE_SUFFIX" = "plist" ]; then
  # shellcheck disable=SC2034 # included from plist.sh
  PLIST_FILE=$CONFIG_FILE
else
  # shellcheck disable=SC2034 # included from ini.sh
  INI_FILE=$CONFIG_FILE
fi