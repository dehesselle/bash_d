# SPDX-License-Identifier: GPL-2.0-or-later
# https://github.com/dehesselle/bash_d

assert_darwin
bash_d_include_guard

### includes ###################################################################

# Nothing here.

### variables ##################################################################

# Nothing here.

### functions ##################################################################

function pkg_expand
{
  local pkg=$1

  local pkg_basename=$(basename -s .pkg "$pkg")
  local pkg_basename_no_spaces=${pkg_basename// /_}  # use underscores

  if [ "$pkg_basename" != "$pkg_basename_no_spaces" ]; then
    pkg_basename=$pkg_basename_no_spaces
    echo_i "replaced spaces with underscores: $pkg_basename_no_spaces"
  fi

  local dir=$(mktemp -u -d $TMP/$pkg_basename.XXX)

  /usr/sbin/pkgutil --expand "$pkg" $dir

  if [ $? -eq 0 ]; then
    find $dir -maxdepth 1 -type d -name "*.pkg" -exec bash -c "cd '{}'; tar xpf Payload" \;
    cd $dir
    echo_o "done"
  else
    echo_e "expansion failed"
  fi
}

### aliases ####################################################################

# Nothing here.

### main #######################################################################

# Nothing here.
