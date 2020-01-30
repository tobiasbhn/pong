#!/bin/bash
set -e

# Remove a potentially pre-existing server.pid for Rails.
rm -f /pong/tmp/pids/server.pid

echo "Preparing Tables ..."
# depends on custom db:exists Task to check if database exists (lib/tasks/db_exists.rake)
# Source: https://stackoverflow.com/a/35732641
rake db:exists && rake db:migrate || rake db:setup

# Then exec the container's main process (what's set as CMD in the Dockerfile).
exec "$@"