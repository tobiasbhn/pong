#!/bin/bash
set -e

# Remove a potentially pre-existing server.pid for Rails.
rm -f /pong/tmp/pids/server.pid

yarn install --check-files
bin/rails assets:precompile

rake db:create
rake db:migrate

# Then exec the container's main process (what's set as CMD in the Dockerfile).
exec "$@"