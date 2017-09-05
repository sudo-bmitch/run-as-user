#!/bin/sh

set -x
# get uid/gid
USER_UID=`ls -nd /home/myuser | cut -f3 -d' '`
USER_GID=`ls -nd /home/myuser | cut -f4 -d' '`

# get the current uid/gid of myuser
CUR_UID=`getent passwd myuser | cut -f3 -d: || true`
CUR_GID=`getent group myuser | cut -f3 -d: || true`

# if they don't match, adjust
if [ ! -z "$USER_GID" -a "$USER_GID" != "$CUR_GID" ]; then
  groupmod -g ${USER_GID} myuser
fi
if [ ! -z "$USER_UID" -a "$USER_UID" != "$CUR_UID" ]; then
  usermod -u ${USER_UID} myuser
  # fix other permissions
  find / -mount -uid ${CUR_UID} -exec chown ${USER_UID}.${USER_GID} {} \;
fi

# drop access to myuser and run cmd
exec gosu myuser "$@"
