include_guard

### includes ###################################################################

# Nothing here.

### variables ##################################################################

# Nothing here.

### functions ##################################################################

function path_remove
{ # https://stackoverflow.com/q/370047
  local to_be_removed=$1

  export PATH=$(echo -n $PATH | 
                awk -v RS=: -v ORS=: '$0 != "'$to_be_removed'"' |
                sed 's/:$//')
}

### aliases ####################################################################

# show directories that are in PATH
alias path_show='echo -e ${PATH//:/\\n}'

### main #######################################################################

# Nothing here.