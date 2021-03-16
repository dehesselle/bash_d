platform_darwin_only
include_guard

### description ################################################################

# FIXME: mount will fail if not owner of mountpoint

### includes ###################################################################

include_file echo.sh

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
      if [ $(/sbin/mount | grep "$dir" | wc -l) -eq 0 ]; then
        # create ramdisk device
        local device
        device=$(hdiutil attach -nomount ram://$size_numsectors)
        local rc=$?

        if [ $rc -eq 0 ]; then
          if [ -z $name ]; then
            name="RAMDISK"  # TODO: make unique?
          fi
          # create filesystem in ramdisk device
          /sbin/newfs_hfs -v "$name" $device
          rc=$?

          if [ $rc -eq 0 ]; then
            # mount volume, hidden in Finder
            /sbin/mount -o noatime,nobrowse -t hfs $device $dir
            rc=$?

            if [ $rc -eq 0 ]; then
              chmod 775 $dir
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
