# SPDX-License-Identifier: GPL-2.0-or-later
# https://github.com/dehesselle/bash_d

assert_darwin

### includes ###################################################################

bash_d_include developer.sh

### variables ##################################################################

# Nothing here.

### functions ##################################################################

function codesign_file
{
  local file=$1
  local options=$2   # optional

  codesign --verbose --options runtime --timestamp $options --sign "$DEVELOPER_ID" $file
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