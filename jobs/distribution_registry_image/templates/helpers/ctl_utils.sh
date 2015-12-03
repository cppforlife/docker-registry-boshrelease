# If loaded within monit ctl scripts then pipe output
# If loaded from 'source ../utils.sh' then normal STDOUT
redirect_output() {
  SCRIPT=$1
  mkdir -p /var/vcap/sys/log/monit
  exec 1>> /var/vcap/sys/log/monit/$SCRIPT.log
  exec 2>> /var/vcap/sys/log/monit/$SCRIPT.err.log
}

pid_guard() {
  pidfile=$1
  name=$2

  if [ -f "$pidfile" ]; then
    pid=$(head -1 "$pidfile")

    if [ -n "$pid" ] && [ -e /proc/$pid ]; then
      echo "$name is already running, please stop it first"
      exit 1
    fi

    echo "Removing stale pidfile..."
    rm $pidfile
  fi
}
