#!/usr/bin/env bash
################################
apt-get update
apt-get -y purge python-dialog
apt-get -y install python-dialog
apt-get install -y letsencrypt -t jessie-backports
