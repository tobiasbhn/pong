#!/bin/bash
set -e

# Remove a potentially pre-existing server.pid for Rails.
rm -f /pong/tmp/pids/server.pid

echo "Checking yarn installations ..."
yarn install --check-files &> /dev/null
echo "Precompiling assets ..."
bin/rails assets:precompile &> /dev/null

echo "Preparing Tables ..."
rake db:create &> /dev/null
rake db:migrate &> /dev/null

# Then exec the container's main process (what's set as CMD in the Dockerfile).
exec "$@"