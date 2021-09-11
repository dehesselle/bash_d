# SPDX-License-Identifier: GPL-2.0-or-later
# https://github.com/dehesselle/bash_d

assert_darwin
include_guard

### includes ###################################################################

# Nothing here.

### variables ##################################################################

# Nothing here.

### functions ##################################################################

function dmg_from_folder()
{
  local source=$1
  local target=$2

  local volname=$(cd $source; basename $(pwd .))

  if [ -z $target ]; then
    target=$source/../$volname.dmg
  fi

  # ULFO: LZFSE compression, available on 10.11+
  # UDBZ: BZ2 compression, best but slow
  hdiutil create -fs HFS+ -ov -format UDBZ -srcfolder "$source" -volname "$volname" "$target"
}

### aliases ####################################################################

# Nothing here.

### main #######################################################################

# Nothing here.
