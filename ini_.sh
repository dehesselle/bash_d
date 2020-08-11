include_guard

### description ################################################################

# This file provides functions to read and write *.ini files. They are only
# suitable for simple cases as a lot of corner cases aren't handled (e.g.
# newlines in values). Also, neither the order of the elements/sections
# will be preserved. Same goes for commentary.

### includes ###################################################################

include_file echo_.sh

### variables ##################################################################

declare -g -A INI_DATA   # key-value store

### functions ##################################################################

function ini_get
{
  if [ $# -eq 1 ]; then
    local section=1default
    local key=$1
  else
    local section=$1
    local key=$2
  fi

   echo ${INI_DATA[$section|$key]}
}

function ini_read
{
  local file=$1

  if [ -f $file ]; then
    while IFS= read -r line; do
      if [[ "$line" =~ ([^|]+)\|([^|]+)\|([^|]*) ]]; then
        local section="${BASH_REMATCH[1]}"
        local key="${BASH_REMATCH[2]}"
        local value="${BASH_REMATCH[3]}"
        #echo "$section.$key.$value"
        INI_DATA[$section|$key]=$value
      fi
    done < <(sed -n '
### Code adopted from
### https://michipili.github.io/shell/2015/06/05/shell-configuration-file.html
###
### Configuration bindings found outside any section are given to the default
### section.
1 {
  x
  s/^/1default/
  x
}
### Lines starting with a #-character are comments.
/^#/n
### Sections are unpacked and stored in the hold space.
/^\[/ {
  s/\[\(.*\)\]/\1/
  x
  b
}
### Bindings are unpacked and decorated with the section they belong to,
### before being printed.
/=/ {
  s/^[[:space:]]*//
  s/[[:space:]]*=[[:space:]]*/|/
  G
  s/\(.*\)\n\(.*\)/\2|\1/
  p
}' $file)
  else
    echo_e "file not found: $file"
    exit 1
  fi
}

function ini_set
{
  if [ $# -eq 2 ]; then
    local section=1default
    local key=$1
    local value=$2
  else
    local section=$1
    local key=$2
    local value=$3
  fi

  INI_DATA[$section|$key]=$value
}

function ini_write
{
  local file=$1

  >$file

  local section
  local section_old

  for key in $(echo ${!INI_DATA[@]} | tr " " "\n" | sort); do
    if [[ "$key" =~ (.+)\|(.+) ]]; then
      section=${BASH_REMATCH[1]}
      key=${BASH_REMATCH[2]}

      if   [ "$section"  = "1default" ]; then
        :    # do not create a section for "globals"
      elif [ "$section" != "$section_old" ]; then
        echo ""           >> $file
        echo "[$section]" >> $file
        section_old=$section
      fi

      echo "$key = ${INI_DATA[$section|$key]}" >> $file
    fi
  done
}

### aliases ####################################################################

# Nothing here.

### main #######################################################################

# Nothing here.
