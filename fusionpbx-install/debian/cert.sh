#!/usr/bin/env bash
domain="call.tklapp.com"
cd "$(dirname "$0")"
perl -pi -e "s/host.domain.nl/${Domain}/g" resources/ssl/_configure.sh
perl -pi -e "s/78784545/${server_address}/g" resources/ssl/_configure.sh
perl -pi -e "s/host.domain.nl/${Domain}/g" resources/ssl/freeCert.sh
cd resources/ssl/
chmod +x *
cd ..
cd ..
resources/ssl/_source.sh
resources/ssl/_install.sh
resources/ssl/freeCert.sh
resources/ssl/_configure.sh
