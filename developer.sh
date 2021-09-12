# SPDX-License-Identifier: GPL-2.0-or-later
# https://github.com/dehesselle/bash_d

bash_d_include_guard

### includes ###################################################################

bash_d_include exit.sh
bash_d_include ini.sh

### variables ##################################################################

DEVELOPER_CREDENTIALS_FILE=$XDG_CONFIG_HOME/apple_developer
DEVELOPER_ID=
DEVELOPER_USERNAME=

### functions ##################################################################

# Nothing here.

### aliases ####################################################################

# Nothing here.

### main #######################################################################

exit_if_file_missing $DEVELOPER_CREDENTIALS_FILE
ini_read $DEVELOPER_CREDENTIALS_FILE
DEVELOPER_ID=$(ini_get developer_id)
DEVELOPER_USERNAME=$(ini_get username)