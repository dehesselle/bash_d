# SPDX-FileCopyrightText: 2021 René de Hesselle <dehesselle@web.de>
#
# SPDX-License-Identifier: GPL-2.0-or-later

### description ################################################################

# Nothing here.

### shellcheck #################################################################

# shellcheck shell=bash # no shebang as this file is intended to be sourced

### includes ###################################################################

bash_d_include echo
bash_d_include keychain

### variables ##################################################################

# Nothing here.

### functions ##################################################################

function github_download_artifact
{
  local url=$1
  local target_dir=$2   # optional, defaults to current directory

  if [[ "$url" =~ https://github.com/([^/]+)/([^/]+)/suites/[0-9]+/artifacts/([0-9]+) ]]; then
    local account=${BASH_REMATCH[1]}
    local repo=${BASH_REMATCH[2]}
    local artifact=${BASH_REMATCH[3]}

    local token
    if !  token=$(keychain_get_password \
                  "github_token" \
                  "download_workflow_artifacts"); then
      echo_e "unable to retrieve token from keychain"
      exit 1
    fi

    local api_url=https://api.github.com/repos/$account/$repo/actions/artifacts/$artifact/zip
    local api_header_auth="Authorization: token $token"
    local api_header_accept="Accept: application/vnd.github.v3+json"

    if [ -z "$target_dir" ]; then
      curl --location --remote-name --remote-header-name \
           --header "$api_header_auth" \
           --header "$api_header_accept" \
           "$api_url"
    else
      local location_url
      location_url=$(\
        curl --location --silent --head \
             --header "$api_header_auth" \
             --header "$api_header_accept" \
             "$api_url" |
        grep "location: https://pipelines.actions.githubusercontent.com" \
      )

      if [[ $location_url =~ artifactName=(.*)\&urlExpires ]]; then
        local artifact_name=${BASH_REMATCH[1]}
      else
        echo_e "unable to retrieve artifactName from location"
        exit 1
      fi

      local target=$target_dir/$artifact_name.zip
      if curl --location --silent \
              --output "$target" \
              --header "$api_header_auth" \
              --header "$api_header_accept" \
              "$api_url"; then
        echo_i "$target"
      else
        echo_e "download failed"
        exit 1
      fi
    fi
  else
    echo_e "unknown URL: $url"
    exit 1
  fi
}

### aliases ####################################################################

# Nothing here.

### main #######################################################################

# Nothing here.
