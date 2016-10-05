#!/usr/bin/env bash
apt-get -y install aptitude && aptitude -y install apt-transport-https

echo " Phase One to start  Done"

echo "#Created by script
#Webmin.com web interface
deb http://download.webmin.com/download/repository sarge contrib
# Turnkey Linux repo
#deb http://archive.turnkeylinux.org/debian jessie main
#Debian Repos
deb http://httpredir.debian.org/debian jessie main
deb-src http://httpredir.debian.org/debian jessie main
# Nginx Webserver
deb http://nginx.org/packages/mainline/debian jessie nginx
deb-src http://nginx.org/packages/mainline/debian jessie nginx
#Debian Backports
deb http://ftp.debian.org/debian jessie-backports main
">/etc/apt/sources.list.d/yoshispreedme.list

echo "#Created by script
#deb http://security.debian.org/ jessie/updates main contrib
#deb-src http://security.debian.org/ jessie/updates main contrib

# jessie-updates, previously known as 'volatile'
# A network mirror was not selected during install.  The following entries
# are provided as examples, but you should amend them as appropriate
# for your mirror of choice.
#
#deb http://ftp.debian.org/debian/ jessie-updates main contrib
#deb-src http://ftp.debian.org/debian/ jessie-updates main contrib
">/etc/apt/sources.list

echo "#Created by script
#deb http://archive.turnkeylinux.org/debian jessie-security main

deb http://security.debian.org/ jessie/updates main
deb http://security.debian.org/ jessie/updates contrib
# deb http://security.debian.org/ jessie/updates non-free
" >/etc/apt/security.sources.list

#echo "deb http://files.freeswitch.org/repo/deb/freeswitch-1.6/ jessie main" > /etc/apt/sources.list.d/freeswitch.list
echo "deb http://ftp.debian.org/debian jessie-backports main" > /etc/apt/sources.list.d/debian-backports.list

echo "### Add Keys Source Keys ####"

wget http://nginx.org/keys/nginx_signing.key
apt-key add nginx_signing.key
rm nginx_signing.key
#cd /etc/apt/trusted.gpg.d/

wget https://download.jitsi.org/jitsi-key.gpg.key
apt-key add jitsi-key.gpg.key
rm jitsi-key.gpg.key
#cp jitsi-key.gpg.key jitsi-key.gpg
#cd ~
wget https://github.com/turnkeylinux/turnkey-keyring/raw/master/turnkey-release-keyring.gpg
apt-key add turnkey-release-keyring.gpg
rm turnkey-release-keyring.gpg

wget http://www.webmin.com/jcameron-key.asc
apt-key add jcameron-key.asc
rm jcameron-key.asc

#wget https://files.freeswitch.org/repo/deb/debian/freeswitch_archive_g0.pub
#apt-key add freeswitch_archive_g0.pub
#rm freeswitch_archive_g0.pub
