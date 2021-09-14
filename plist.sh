# SPDX-FileCopyrightText: 2021 René de Hesselle <dehesselle@web.de>
#
# SPDX-License-Identifier: GPL-2.0-or-later

### description ################################################################

# Simplified acces to property lists as a macOS-specific way to read/write
# configuration files.

### shellcheck #################################################################

# shellcheck shell=bash # no shebang as this file is intended to be sourced

### dependencies ###############################################################

assert_darwin
bash_d_include_guard
bash_d_include echo

### variables ##################################################################

PLIST_FILE=

### functions ##################################################################

function plist_get
{
  local dict=$1
  local key=$2
  local value_default=$3

  if [ $# -eq 2 ]; then
    value_default=$key
    key=$dict
    dict=common
  fi

  if  ! /usr/libexec/PlistBuddy -c "Print $dict:$key" "$PLIST_FILE" 2>/dev/null &&
      [ -n "$value_default" ]; then
    plist_set "$dict" "$key" "$value_default"
    echo "$value_default"
  fi
}

function plist_set
{
  local dict=$1
  local key=$2
  local value=$3
  local type=$4   # optional, defaults to string

  case $# in
    2)  value=$key
        key=$dict
        dict=common
        type=string
        ;;
    3)  type=string
        ;;
  esac

  if ! /usr/libexec/PlistBuddy \
      -c "Set '$dict:$key' '$value'" "$PLIST_FILE" 2>/dev/null; then
    if ! /usr/libexec/PlistBuddy \
        -c "Add '$dict:$key' '$type' '$value'" "$PLIST_FILE" 2>/dev/null; then
      echo_e "unable to set $dict:$key"
      return 1
    fi
  fi
}

function plist_del
{
  local dict=$1
  local key=$2

  if [ $# -eq 1 ]; then
    key=$dict
    dict=common
  fi

  if ! /usr/libexec/PlistBuddy \
      -c "Delete '$dict:$key'" "$PLIST_FILE" 2>/dev/null; then
    echo_e "unable to delete $dict:$key"
    return 1
  fi
}

### aliases ####################################################################

# Nothing here.

### main #######################################################################

# Nothing here.
