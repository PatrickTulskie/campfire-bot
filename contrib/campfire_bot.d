#!/bin/sh
set -e
APP_NAME=campfire_bot
APP_ROOT=/apps/$APP_NAME/current
ENVIRONMENT=production
CONFIG=$APP_ROOT/config/$ENVIRONMENT.yml
PID_DIRECTORY=$APP_ROOT/tmp/pids
PID=$PID_DIRECTORY/$APP_NAME.pid
CMD="bundle exec campfire-bot -c $CONFIG -e $ENVIRONMENT -p $APP_ROOT/plugins -i $PID_DIRECTORY -d -a $APP_NAME"

cd $APP_ROOT || exit 1

sig () {
	test -s "$PID" && kill -$1 `cat $PID`
}

case $1 in
start)
	sig 0 && echo >&2 "Already running" && exit 0
	$CMD
	;;
stop)
	sig QUIT && exit 0
	echo >&2 "Not running"
	;;
restart|reload)
	sig QUIT && $CMD
	;;
*)
	echo >&2 "Usage: $0 <start|stop|restart>"
	exit 1
	;;
esac
