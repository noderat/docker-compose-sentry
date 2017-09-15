#!/usr/bin/env bash

set -e

if [[ ! -z ${WAIT_FOR_POSTGRES+x} ]]; then
  printf "Waiting up to ${WAIT_FOR_POSTGRES} seconds for Postgres... "
  wait-for-it -s -q --timeout=${WAIT_FOR_POSTGRES} ${SENTRY_POSTGRES_HOST:-postgres}:${SENTRY_POSTGRES_PORT:-5432} -- echo "done!"
fi

if [[ ! -z ${WAIT_FOR_REDIS+x} ]]; then
  printf "Waiting up to ${WAIT_FOR_REDIS} seconds for Redis... "
  wait-for-it -s -q --timeout=${WAIT_FOR_REDIS} ${SENTRY_REDIS_HOST:-redis}:${SENTRY_REDIS_PORT:-6379} -- echo "done!"
fi

if [[ ! -z ${WAIT_FOR_SENTRY+x} ]]; then
  printf "Waiting up to ${WAIT_FOR_REDIS} seconds for Sentry... "
  wait-for-it -s -q --timeout=${WAIT_FOR_SENTRY} ${SENTRY_HOST:-sentry}:${SENTRY_PORT:-9000} -- echo "done!"
fi

if [[ ! -z ${COMPOSE_MODE} ]]; then
  echo "Running in docker-compose mode"
  sentry upgrade --noinput | sed 's/.*/[Migration] &/'

  if [[ ! -f "/sentry-superuser-created" ]]; then
    echo "Creating initial superuser"
    sentry createuser --no-input --superuser --email $SENTRY_SUPERUSER_EMAIL --password $SENTRY_SUPERUSER_PASS
    if [ $? -ne 0 ]; then
      echo "Error Creating Superuser!"
      exit 1
    else
      touch /sentry-superuser-created
    fi
  fi
fi

exec "/entrypoint.sh" "$@"