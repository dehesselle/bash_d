# SPDX-License-Identifier: GPL-2.0-or-later
# https://github.com/dehesselle/bash_d

### description ################################################################

# Run a command by spawning (and afterwards closing) an instance of
# Terminal.app. Adapted from:
# https://stackoverflow.com/a/27970527
# https://gist.github.com/masci/ff51d9cf40a87a80094c

### includes ###################################################################

# Nothing here.

### variables ##################################################################

# Nothing here.

### functions ##################################################################


### run script via Terminal.app ################################################

function run_in_terminal
{
  local command=$1

  #local window_id=$(uuidgen)      # this would be really unique but...
  local window_id=$(date +%s)      # ...seconds would help more with debugging

  osascript <<EOF
tell application "Terminal"
  set _tab to do script "echo -n -e \"\\\033]0;$window_id\\\007\"; $command; exit"
  delay 1
  repeat while _tab is busy
    delay 1
  end repeat
  close (every window whose name contains "$window_id")
end tell
EOF
}

### aliases ####################################################################

# Nothing here.

### main #######################################################################

# Nothing here.