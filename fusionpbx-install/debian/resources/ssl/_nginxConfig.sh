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

server{
	listen 127.0.0.1:80;
	server_name 127.0.0.1;
	access_log /var/log/nginx/access.log;
	error_log /var/log/nginx/error.log;

	client_max_body_size 80M;
	client_body_buffer_size 128k;

	location / {
		root /var/www/fusionpbx;
		index index.php;
	}

	location ~ \.php$ {
		fastcgi_pass unix:/var/run/php5-fpm.sock;
		#fastcgi_pass 127.0.0.1:9000;
		fastcgi_index index.php;
		include fastcgi_params;
		fastcgi_param   SCRIPT_FILENAME /var/www/fusionpbx$fastcgi_script_name;
	}

	# Disable viewing .htaccess & .htpassword & .db
	location ~ .htaccess {
			deny all;
	}
	location ~ .htpassword {
			deny all;
	}
	location ~^.+.(db)$ {
			deny all;
	}
}

server {
	listen 80;
	server_name fusionpbx;
	if ($uri !~* ^.*provision.*$) {
		rewrite ^(.*) https://$host$1 permanent;
		break;
	}

	#REST api
	if ($uri ~* ^.*/api/.*$) {
		rewrite ^(.*)/api/(.*)$ $1/api/index.php?rewrite_uri=$2 last;
		break;
	}

	#mitel
	rewrite "^.*/provision/MN_([A-Fa-f0-9]{12})\.cfg" /app/provision/index.php?mac=$1&file=MN_%7b%24mac%7d.cfg last;
	rewrite "^.*/provision/MN_Generic.cfg" /app/provision/index.php?mac=08000f000000&file=MN_Generic.cfg last;

	#grandstream
	rewrite "^.*/provision/cfg([A-Fa-f0-9]{12})(\.(xml|cfg))?$" /app/provision/?mac=$1;

	#aastra
	rewrite "^.*/provision/aastra.cfg$" /app/provision/?mac=$1&file=aastra.cfg;
	#rewrite "^.*/provision/([A-Fa-f0-9]{12})(\.(cfg))?$" /app/provision/?mac=$1 last;

	#yealink common
	rewrite "^.*/provision/(y[0-9]{12})(\.cfg)?$" /app/provision/index.php?file=$1.cfg;

	#yealink mac
	rewrite "^.*/provision/([A-Fa-f0-9]{12})(\.(xml|cfg))?$" /app/provision/index.php?mac=$1 last;

	#polycom
	rewrite "^.*/provision/000000000000.cfg$" "/app/provision/?mac=$1&file={%24mac}.cfg";
	#rewrite "^.*/provision/sip_330(\.(ld))$" /includes/firmware/sip_330.$2;
	rewrite "^.*/provision/features.cfg$" /app/provision/?mac=$1&file=features.cfg;
	rewrite "^.*/provision/([A-Fa-f0-9]{12})-sip.cfg$" /app/provision/?mac=$1&file=sip.cfg;
	rewrite "^.*/provision/([A-Fa-f0-9]{12})-phone.cfg$" /app/provision/?mac=$1;
	rewrite "^.*/provision/([A-Fa-f0-9]{12})-registration.cfg$" "/app/provision/?mac=$1&file={%24mac}-registration.cfg";
	rewrite "^.*/provision/([A-Fa-f0-9]{12})-directory.xml$" "/app/provision/?mac=$1&file={%24mac}-directory.xml";

	#cisco
	rewrite "^.*/provision/file/(.*\.(xml|cfg))" /app/provision/?file=$1 last;

	#Escene
	rewrite "^.*/provision/([0-9]{1,11})_Extern.xml$"       "/app/provision/?ext=$1&file={%24mac}_extern.xml" last;
	rewrite "^.*/provision/([0-9]{1,11})_Phonebook.xml$"    "/app/provision/?ext=$1&file={%24mac}_phonebook.xml" last;

	access_log /var/log/nginx/access.log;
	error_log /var/log/nginx/error.log;

	client_max_body_size 80M;
	client_body_buffer_size 128k;

	location / {
		root /var/www/fusionpbx;
		index index.php;
	}

	location ~ \.php$ {
		fastcgi_pass unix:/var/run/php5-fpm.sock;
		#fastcgi_pass 127.0.0.1:9000;
		fastcgi_index index.php;
		include fastcgi_params;
		fastcgi_param   SCRIPT_FILENAME /var/www/fusionpbx$fastcgi_script_name;
	}

	# Disable viewing .htaccess & .htpassword & .db
	location ~ .htaccess {
		deny all;
	}
	location ~ .htpassword {
		deny all;
	}
	location ~^.+.(db)$ {
		deny all;
	}
}

server {
	listen 443;
	server_name fusionpbx;
	ssl                     on;
	ssl_certificate         /etc/letsencrypt/live/DOMAIN/fullchain.pem;
	ssl_certificate_key     /etc/letsencrypt/live/DOMAIN/privkey.pem;
	ssl_protocols           TLSv1 TLSv1.1 TLSv1.2;
	ssl_ciphers             HIGH:!ADH:!MD5;

	#REST api
	if ($uri ~* ^.*/api/.*$) {
		rewrite ^(.*)/api/(.*)$ $1/api/index.php?rewrite_uri=$2 last;
		break;
	}

	#mitel
	rewrite "^.*/provision/MN_([A-Fa-f0-9]{12})\.cfg" /app/provision/index.php?mac=$1&file=MN_%7b%24mac%7d.cfg last;
	rewrite "^.*/provision/MN_Generic.cfg" /app/provision/index.php?mac=08000f000000&file=MN_Generic.cfg last;

	#grandstriam
	rewrite "^.*/provision/cfg([A-Fa-f0-9]{12})(\.(xml|cfg))?$" /app/provision/?mac=$1;

	#aastra
	rewrite "^.*/provision/aastra.cfg$" /app/provision/?mac=$1&file=aastra.cfg;
	#rewrite "^.*/provision/([A-Fa-f0-9]{12})(\.(cfg))?$" /app/provision/?mac=$1 last;

	#yealink common
	rewrite "^.*/provision/(y[0-9]{12})(\.cfg)?$" /app/provision/index.php?file=$1.cfg;

	#yealink mac
	rewrite "^.*/provision/([A-Fa-f0-9]{12})(\.(xml|cfg))?$" /app/provision/index.php?mac=$1 last;

	#polycom
	rewrite "^.*/provision/000000000000.cfg$" "/app/provision/?mac=$1&file={%24mac}.cfg";
	#rewrite "^.*/provision/sip_330(\.(ld))$" /includes/firmware/sip_330.$2;
	rewrite "^.*/provision/features.cfg$" /app/provision/?mac=$1&file=features.cfg;
	rewrite "^.*/provision/([A-Fa-f0-9]{12})-sip.cfg$" /app/provision/?mac=$1&file=sip.cfg;
	rewrite "^.*/provision/([A-Fa-f0-9]{12})-phone.cfg$" /app/provision/?mac=$1;
	rewrite "^.*/provision/([A-Fa-f0-9]{12})-registration.cfg$" "/app/provision/?mac=$1&file={%24mac}-registration.cfg";

	#cisco
	rewrite "^.*/provision/file/(.*\.(xml|cfg))" /app/provision/?file=$1 last;

	#Escene
	rewrite "^.*/provision/([0-9]{1,11})_Extern.xml$"       "/app/provision/?ext=$1&file={%24mac}_extern.xml" last;
	rewrite "^.*/provision/([0-9]{1,11})_Phonebook.xml$"    "/app/provision/?ext=$1&file={%24mac}_phonebook.xml" last;

	access_log /var/log/nginx/access.log;
	error_log /var/log/nginx/error.log;

	client_max_body_size 80M;
	client_body_buffer_size 128k;

	location / {
		root /var/www/fusionpbx;
		index index.php;
	}

	location ~ \.php$ {
		fastcgi_pass unix:/var/run/php5-fpm.sock;
		#fastcgi_pass 127.0.0.1:9000;
		fastcgi_index index.php;
		include fastcgi_params;
		fastcgi_param   SCRIPT_FILENAME /var/www/fusionpbx$fastcgi_script_name;
	}

	# Disable viewing .htaccess & .htpassword & .db
	location ~ .htaccess {
		deny all;
	}
	location ~ .htpassword {
		deny all;
	}
	location ~^.+.(db)$ {
		deny all;
	}
}