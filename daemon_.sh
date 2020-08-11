# SPDX-License-Identifier: GPL-2.0-or-later
# https://github.com/dehesselle/bash_d

include_guard

### description ################################################################

# This file provides functions to write simple daemons. You basically have
# to override the function daemon_run with whatever you want to run and call
# 'daemon_dispatch $1' as main function to get going.

### includes ###################################################################

include_file echo_.sh

### variables ##################################################################

DAEMON_PIDFILE=/tmp/$(basename $0).pid
DAEMON_SHUTDOWN_GRACE=20

### functions ##################################################################

function daemon_dispatch
{
  local command=$1

  case "$command" in
    start)
      local pid=0
      if [ -f $DAEMON_PIDFILE ]; then
         pid=$(cat $DAEMON_PIDFILE)
      fi
      if [ $pid -ne 0 ]; then
         if [ $(ps -p $pid >/dev/null 2>&1; echo $?) -eq 0 ]; then
            echo_e "already running as pid $pid"
            return 1
         else
            echo_w "found a stale pidfile"
         fi
      fi
      daemon_start
      ;;
    restart|status|stop)
      daemon_$command
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
  daemon_stop
  if [ $? -eq 0 ]; then
    daemon_start
  fi
}

function daemon_run
{
  echo_e "You need to override this function."
  echo $BASHPID > $DAEMON_PIDFILE
}

function daemon_start
{
  if [ -f $DAEMON_PIDFILE ]; then
    rm $DAEMON_PIDFILE
  fi

  daemon_run &

  local seconds=0
  while [ ! -f $DAEMON_PIDFILE ] && [ $seconds -lt 10 ]; do
    ((seconds+=1))
    sleep 1
  done

  if [ -f $DAEMON_PIDFILE ]; then
    echo_o "process started as pid $(cat $DAEMON_PIDFILE)"
  else
    echo_e "no pidfile created"
  fi
}

function daemon_status
{
  if [ -f $DAEMON_PIDFILE ]; then
    local pid=$(cat $DAEMON_PIDFILE)

    if [ $(ps -p $pid >/dev/null 2>&1; echo $?) -eq 0 ]; then
      echo_i "pid $pid is alive"
    else
      echo_w "pid $pid has died"
    fi
  else
    echo_i "process is not running"
  fi
}

function daemon_stop
{
  if [ -f $DAEMON_PIDFILE ]; then
    local pid=$(cat $DAEMON_PIDFILE)

    if [ $(ps -p $pid >/dev/null 2>&1; echo $?) -eq 0 ]; then
      kill -TERM $pid

      local seconds=0
      while [ $(ps -p $pid >/dev/null 2>&1; echo $?) -eq 0 ] && [ $seconds -lt $DAEMON_SHUTDOWN_GRACE ]; do
        echo_i "waiting for pid $pid to shut down..."
        sleep 5
        ((seconds+=5))
      done

      if [ $seconds -gt $DAEMON_SHUTDOWN_GRACE ]; then
        echo_e "pid $pid failed to shut down after $seconds seconds"
        return 1
      else
        echo_o "shut down"
        rm $DAEMON_PIDFILE
        return 0
      fi
    else
      echo_w "pid $pid was already gone"
      rm $DAEMON_PIDFILE
    fi
  else
    echo_e "no process running"
  fi
}

### aliases ####################################################################

# Nothing here.

### main #######################################################################

# Nothing here.