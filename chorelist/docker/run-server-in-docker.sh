#!/usr/bin/env  bash

set euo pipefail

cd ${INSTALL_PATH}

bundle install
bin/rails db:prepare
bin/rails assets:precompile
# bin/rails server -e production -p 80
bin/rails server -e production -p 80
