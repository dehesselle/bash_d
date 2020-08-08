include_guard

### includes ###################################################################

# Nothing here.

### variables ##################################################################

# Nothing here.

### functions ##################################################################

function inkscape_to_alpha
{
  local file=$1

  [ -z $file ] && file=$HOME/.ramdisk/110-create_release.sh/Inkscape*.dmg

  if [ -z $file ]; then
    echo "$FUNCNAME file not found: $file"
    exit 1
  fi

  scp $file alpha:/var/www/alpha.inkscape.org/public_html/prereleases
}

### aliases ####################################################################

# Nothing here.

### main #######################################################################

# Nothing here.