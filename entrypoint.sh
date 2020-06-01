#!/bin/bash
set -e
val=$(ls -A /var/db/tang/*.jwk 2>/dev/null | wc -l)
if [ $val -eq 0 ]
then
	echo "Generating new tang keys..."
	/usr/libexec/tangd-keygen /var/db/tang
	/usr/libexec/tangd-update /var/db/tang /var/cache/tang
else
	echo "Reusing existing tang keys in /var/db/tang"
fi
exec "$@"
