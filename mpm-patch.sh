#!/bin/bash
set -eux

a2dismod mpm_event mpm_worker || true
a2enmod mpm_prefork || true

exec docker-entrypoint.sh "$@"
