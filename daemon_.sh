include_guard

### description ################################################################

# This file provides functions to write simple daemons.

### includes ###################################################################

include_file echo_.sh

### variables ##################################################################

DAEMON_PIDFILE=$TMPDIR/$(basename $0).pid

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
}

function daemon_start
{
  daemon_run &

  local pid=$!
  echo $pid > $DAEMON_PIDFILE
  echo_i "started as pid $pid"
}

function daemon_status
{
  if [ -f $DAEMON_PIDFILE ]; then
    local pid=$(cat $DAEMON_PIDFILE)

    if [ $(ps -p $pid >/dev/null 2>&1; echo $?) -eq 0 ]; then
      echo_i "pid $pid is alive"
    else
      echo_i "pid $pid has died"
    fi
  else
    echo_i "process is not running"
  fi
}

function daemon_stop
{
  if [ -f $DAEMON_PIDFILE ]; then
    local pid=$(cat $DAEMON_PIDFILE)
    echo_i "stopping pid $pid"
    kill -TERM $pid

    local seconds=0
    while [ $(ps -p $pid >/dev/null 2>&1; echo $?) -eq 0 ] && [ $seconds -lt 6 ]; do
      echo_i "waiting for process to shut down"
      sleep 1
      ((seconds++))
    done

    if [ $seconds -eq 6 ]; then
      echo_e "pid $pid failed to shutdown after $seconds seconds"
      return 1
    else
      rm $DAEMON_PIDFILE
      return 0
    fi
  else
    echo_e "no process running"
  fi
}

### aliases ####################################################################

# Nothing here.

### main #######################################################################

# Nothing here.