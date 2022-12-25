#!/usr/bin/env  bash

set euo pipefail

cd ${INSTALL_PATH}

bundle install
echo "CHECKING FOR MASTER KEY in ${INSTALL_PATH}/config/master.key"
if [[ ! -f "${INSTALL_PATH}/config/master.key" ]]; then
    rm "${INSTALL_PATH}/config.credentials.yml.enc"
    echo "Creating new master key"
    EDITOR=true bin/rails credentials:edit > /dev/null
fi
bin/rails db:prepare

echo "Precompiling assets.  RAILS_ENV=${RAILS_ENV}"
bin/rails assets:precompile
bin/rails server -e production -p 80
