#!/bin/bash
set -e
/usr/libexec/tangd-keygen /var/db/tang
/usr/libexec/tangd-update /var/db/tang /var/cache/tang

exec "$@"
