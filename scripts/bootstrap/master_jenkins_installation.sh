#!/bin/bash

sudo adduser $USER vboxsf

echo "Downloading Jenkins"
wget -q -O - https://pkg.jenkins.io/debian/jenkins.io.key | sudo apt-key add -
sudo sh -c 'echo deb https://pkg.jenkins.io/debian binary/ > \
    /etc/apt/sources.list.d/jenkins.list'
sudo apt-get update
sudo apt-get install jenkins
# Stop jenkins to move to a new locations
sudo systemctl stop jenkins
# Delete existing folder
sudo rm -rf /var/lib/jenkins
# Add jenkins user to the shared bug-bounty folder
sudo adduser jenkins vboxsf
# Copy config jenkins config file
sudo cp jenkins /etc/default/jenkins
sudo systemctl start jenkins