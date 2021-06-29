# SPDX-FileCopyrightText: 2021 René de Hesselle <dehesselle@web.de>
#
# SPDX-License-Identifier: GPL-2.0-or-later

### description ################################################################

# Provides functions to write simple daemons. You basically have
# to override the function daemon_run with whatever you want to run and call
# 'daemon_dispatch $1' as main function to get going.

### shellcheck #################################################################

# shellcheck shell=bash # no shebang as this file is intended to be sourced

### includes ###################################################################

include_guard

include_file echo
include_file xdg

### variables ##################################################################

DAEMON_NAME=process
DAEMON_PIDFILE=$XDG_RUNTIME_DIR/$(basename -- "$0").pid
DAEMON_SHUTDOWN_GRACE=20

### functions ##################################################################

function daemon_dispatch
{
  local command=$1

  local pid_dir
  pid_dir=$(dirname "$DAEMON_PIDFILE")
  if [ ! -d "$pid_dir" ]; then
    if mkdir -p "$pid_dir"; then
      echo_e "failed to create directory for pid: $pid_dir"
      return 1
    fi
  fi

  case "$command" in
    start)
      declare -i pid=0
      if [ -f "$DAEMON_PIDFILE" ]; then
         pid=$(cat "$DAEMON_PIDFILE")
      fi
      if [ "$pid" -ne 0 ]; then
         if [ "$(ps -p "$pid" >/dev/null 2>&1; echo $?)" -eq 0 ]; then
            echo_e "$DAEMON_NAME running as pid $pid"
            return 1
         else
            echo_w "found a stale pidfile"
         fi
      fi
      daemon_start
      ;;
    restart|status|stop)
      daemon_"$command"
      ;;
    *)
      daemon_print_usage
      ;;
  esac

  return 0
}

function daemon_print_usage
{
  echo_i "usage: $0 {start|stop|restart|status}"
}

function daemon_restart
{
  if daemon_stop; then
    daemon_start
  fi
}

function daemon_run
{
  echo_e "You need to override this function."
  echo $BASHPID > "$DAEMON_PIDFILE"   # you need to provide the pid
}

function daemon_start
{
  if [ -f "$DAEMON_PIDFILE" ]; then
    rm "$DAEMON_PIDFILE"
  fi

  daemon_run &

  declare -i seconds=0
  while [ ! -f "$DAEMON_PIDFILE" ] && [ $seconds -lt 10 ]; do
    ((seconds+=1))
    sleep 1
  done

  if [ -f "$DAEMON_PIDFILE" ]; then
    echo_o "$DAEMON_NAME started as pid $(cat "$DAEMON_PIDFILE")"
  else
    echo_e "no pidfile created"
  fi
}

function daemon_status
{
  if [ -f "$DAEMON_PIDFILE" ]; then
    declare -i pid
    pid=$(cat "$DAEMON_PIDFILE")

    if [ "$(ps -p "$pid" >/dev/null 2>&1; echo $?)" -eq 0 ]; then
      echo_i "$DAEMON_NAME is alive (pid $pid)"
    else
      echo_w "$DAEMON_NAME has died (pid $pid)"
    fi
  else
    echo_i "$DAEMON_NAME is not running"
  fi
}

function daemon_stop
{
  if [ -f "$DAEMON_PIDFILE" ]; then
    local pid
    pid=$(cat "$DAEMON_PIDFILE")

    if [ "$(ps -p "$pid" >/dev/null 2>&1; echo $?)" -eq 0 ]; then
      kill -TERM "$pid"

      declare -i seconds=0
      while [ "$(ps -p "$pid" >/dev/null 2>&1; echo $?)" -eq 0 ] && [ $seconds -lt $DAEMON_SHUTDOWN_GRACE ]; do
        echo_i "waiting for $DAEMON_NAME (pid $pid) to shut down..."
        sleep 5
        ((seconds+=5))
      done

      if [ "$seconds" -gt $DAEMON_SHUTDOWN_GRACE ]; then
        echo_e "$DAEMON_NAME (pid $pid) failed to shut down after $seconds seconds"
        return 1
      else
        echo_o "shut down"
        rm "$DAEMON_PIDFILE"
        return 0
      fi
    else
      echo_w "$DAEMON_NAME (pid $pid) was already gone"
      rm "$DAEMON_PIDFILE"
      return 0
    fi
  else
    echo_w "$DAEMON_NAME isn't running"
    return 1
  fi
}

### aliases ####################################################################

# Nothing here.

### main #######################################################################

# Nothing here.