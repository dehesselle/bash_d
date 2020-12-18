# SPDX-License-Identifier: GPL-2.0-or-later
# https://github.com/dehesselle/bash_d

platform_darwin_only
include_guard

### includes ###################################################################

# Nothing here.

### variables ##################################################################

# Nothing here.

### functions ##################################################################

function sparsebundle_create
{
  local name=$1
  local size=${2,,}
  local sparse_band_size=${3^^}   # optional

  [ -z $sparse_band_size ] && sparse_band_size=8M

  sparse_band_size=$($HOMEBREW_PREFIX/bin/numfmt --from=iec ${sparse_band_size^^})
  sparse_band_size=$(expr $sparse_band_size / 512)

  hdiutil create \
    -fs JHFS+ \
    -nospotlight \
    -size $size \
    -tgtimagekey sparse-band-size=$sparse_band_size \
    -type SPARSEBUNDLE \
    -volname $name \
    $name
}

### aliases ####################################################################

# Nothing here.

### main #######################################################################

# Nothing here.
