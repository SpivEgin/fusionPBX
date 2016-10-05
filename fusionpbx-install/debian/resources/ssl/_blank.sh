#!/usr/bin/env bash
# Simple script to setup a webrtc enabled lab with freeswitch, nginx, letsencrypt certificates and verto_communicator.
# Adapt the DOMAIN & IP variables below and launch as root on on a freshly minimal installed debian 8 ( jessie ) server.
# DO NOT USE IN PRODUCTION, it's for PoC purposes.
# Freeswich config is the default vanilla demo config, you SHOULD CHANGE the DEFAULT PASSWORDS ( extensions, event_socket, etc ... )
# At the end of the script, you can navigate to https://$DOMAIN/vc and enjoy verto communicator up & running !
# Author: "Tristan Mahe" <gled@remote-shell.net>
# License: WTFPL
################################
DOMAIN="host.domain.nl" ############## Must Change to the correct settings your information
IP="78784545"  ##############
################################
