#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

if [ ! -f $DATA_DIR/.db_created ]; then

    if [ -z "${DB_URL}" ]; then
        echo 'The DB_URL environment variable was not set. This value is required.'
        exit 1
    fi

    $DIR/update-config.py
    $DIR/createdb.py
    #alembic -c /opt/anitya/alembic.ini upgrade head
    touch $DATA_DIR/.db_created
fi

 uwsgi \
 --chdir $ANITYA_HOME \
 --http-socket 0.0.0.0:$ANITYA_APP_PORT \
 --manage-script-name \
 --mount /=app:app \
 --stats 0.0.0.0:$ANITYA_STATS_PORT \
 --stats-http