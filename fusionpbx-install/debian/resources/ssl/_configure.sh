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
cat /etc/letsencrypt/live/$DOMAIN/fullchain.pem /etc/letsencrypt/live/$DOMAIN/privkey.pem > /etc/freeswitch/tls/wss.pem

perl -i -pe 's/# listen/listen/g' /etc/nginx/sites-enabled/default
perl -i -pe 's/root \/var\/www\/html;/root \/var\/www\/html\/vc;/g' /etc/nginx/sites-enabled/default
perl -i -pe 's/# include snippets\/snakeoil.conf/include snippets\/letsencrypt.conf/g' /etc/nginx/sites-enabled/default

echo "ssl_certificate /etc/letsencrypt/live/$DOMAIN/fullchain.pem;" >> /etc/nginx/snippets/letsencrypt.conf
echo "ssl_certificate_key /etc/letsencrypt/live/$DOMAIN/privkey.pem;" >> /etc/nginx/snippets/letsencrypt.conf

systemctl reload nginx
