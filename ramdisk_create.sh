assert_darwin

### description ################################################################

# FIXME: mount will fail if not owner of mountpoint

### includes ###################################################################

bash_d_include echo.sh

### variables ##################################################################

# Nothing here.

### functions ##################################################################

function ramdisk_create
{
  local size=$1   # unit is GiB
  local dir=$2    # mountpoint (optional)
  local name=$3   # partition name (optional)

  if [ $# -eq 0 ]; then
    echo "usage: $FUNCNAME <size in GiB> [<target dir>]"
  else
    local size_numsectors=$(expr $size \* 1024 \* 2048)

    if [ -z $dir ]; then   # If no directory has been given, let diskutil
                           # handle everything, i.e. creating a ramdisk below
                           # '/Volumes'.
      name="RAM${size}G_$(whoami)"  # TODO: make unique
      local dir=/Volumes/$name

      if [ $(/sbin/mount | grep "$dir" | wc -l) -eq 0 ]; then
        # create ramdisk and mount with Volume visible in Finder
        /usr/sbin/diskutil erasevolume HFS+ "$name" \
            $(hdiutil attach -nomount ram://$size_numsectors)
        local rc=$?

        if [ $rc -eq 0 ]; then
          echo_o "ramdisk created: $dir"
        else
          echo_e "ramdisk not created: $dir"
        fi
      else
        echo_e "mountpoint already in use: $dir"
      fi
    else   # If a directory has been given, we cannot use diskutil but need
           # to peform the necessary steps ourselves so we can set the
           # mountpoint.
      if [ "$(/sbin/mount | grep -c "$dir")" -eq 0 ]; then
        # create ramdisk device
        local device
        if device=$(hdiutil attach -nomount ram://"$size_numsectors"); then
          if [ -z "$name" ]; then
            name="RAMDISK"  # TODO: make unique?
          fi
          # create filesystem in ramdisk device
          if /sbin/newfs_hfs -v "$name" $device; then  # device unquoted on purpose!
            # mount volume, hidden in Finder
            if /usr/sbin/diskutil mount -mountOptions noatime,nobrowse -mountPoint "$dir" $device; then
              chmod 775 "$dir"
              echo_o "$dir"
            else
              echo_e "failed to mount ramdisk"
            fi
          else
            echo_e "failed to create filesystem"
          fi
        else
          echo_e "failed to create device"
        fi
      else
        echo_e "mountpoint already in use: $dir"
      fi
    fi
  fi
}

### aliases ####################################################################

# Nothing here.

### main #######################################################################

# Nothing here.
