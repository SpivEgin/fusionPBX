#!/usr/bin/env bash
domain="call.tklapp.com"
cd "$(dirname "$0")"
resources/ssl/_install.sh
resources/ssl/freeCert.sh
resources/ssl/_configure.sh