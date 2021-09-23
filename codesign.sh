# SPDX-FileCopyrightText: 2021 René de Hesselle <dehesselle@web.de>
#
# SPDX-License-Identifier: GPL-2.0-or-later

### description ################################################################

# Conveneince handling for signing software.

### shellcheck #################################################################

# shellcheck shell=bash # no shebang as this file is intended to be sourced

### dependencies ###############################################################

bash_d_include developer

### variables ##################################################################

# Nothing here.

### functions ##################################################################

function codesign_file
{
  local file=$1
  local options=$2   # optional

  codesign --verbose --options runtime --timestamp $options --sign "$(developer_get_id)" $file
}

function codesign_files
{
  local dir=$1
  local options=$2   # optional

  for file in $(find $dir -type f -maxdepth 1); do
    codesign_file $file $options
  done
}

function codesign_libs_recursively
{
  local start_dir=$1
  local options=$2   # optional

  for lib in $(find $start_dir -name '*.dylib' -o -name '*.so'); do
    codesign_file $lib $options
  done
}

### aliases ####################################################################

alias codesign_developerid_show='codesign -dv --verbose=4'
alias codesign_invalidresource_show='codesign --verify --deep --verbose'

### main #######################################################################

# Nothing here.