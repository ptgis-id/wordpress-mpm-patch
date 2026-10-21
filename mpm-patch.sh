#!/bin/bash
set -eux

a2dismod mpm_event mpm_worker || true
a2enmod mpm_prefork || true

su -s /bin/sh www-data -c /usr/local/bin/upgrade-wordpress.sh

exec docker-entrypoint.sh "$@"
