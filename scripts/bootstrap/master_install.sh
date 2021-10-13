#!/bin/bash
sudo add-apt-repository ppa:longsleep/golang-backports
sudo apt -y update
sudo adduser $USER vboxsf

sudo apt install -y \
apt-transport-https \
ca-certificates \
gnupg \
lsb-release \
net-tools \
libcurl4-openssl-dev libssl-dev \
jq \
ruby-full \
libcurl4-openssl-dev libxml2 libxml2-dev libxslt1-dev ruby-dev build-essential libgmp-dev zlib1g-dev \
build-essential libssl-dev libffi-dev python-dev \
libmysqlclient-dev \
python-setuptools \
libldns-dev \
python3-pip \
python-dnspython \
git \
rename \
xargs \
tmux \
vim \
nmap \
curl \
golang-go \
openssh-server \
openjdk-11-jdk openjdk-11-jre
sudo snap install amass

sudo systemctl enable ssh
sudo systemctl start ssh

# install common python3 libraries
pip3 install boto3 requests lxml ipparser

echo "Installing docker"
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get install docker-ce docker-ce-cli containerd.io
echo "done"

echo "Installing bash_profile aliases from recon_profile"
cat .bash_profile >> ~/.bash_profile
source ~/.bash_profile
echo "source ~/.bash_profile" >> ~/.bashrc
echo "done"

# Setting up tmux
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
tmux source .tmux.conf
# echo "tmux source ~/.tmux.conf" >> ~/.bashrc

#Don't forget to set up AWS credentials!
echo "Don't forget to set up AWS credentials!"
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

#create a tools folder in ~/
mkdir ~/tools
cd ~/tools/

#install patator
echo "Installing Patator"
git clone https://github.com/lanjelot/patator
cd patator
sudo python3 setup.py install
cd ~/tools/
echo "done"

#install eyewitness
echo "Installing EyeWitness"
git clone https://github.com/FortyNorthSecurity/EyeWitness.git
cd EyeWitness
cd setup
sudo ./setup.sh
cd ~/tools/
echo "done"

echo "Installing teh_s3_bucketeers"
git clone https://github.com/tomdev/teh_s3_bucketeers.git
cd ~/tools/
echo "done"

echo "Installing wpscan"
git clone https://github.com/wpscanteam/wpscan.git
cd wpscan
sudo gem install bundler && bundle install --without test
cd ~/tools/
echo "done"

echo "Installing joomscan"
git clone https://github.com/rezasp/joomscan.git
cd ~/tools/
echo "done"

echo "Installing dirsearch"
git clone https://github.com/maurosoria/dirsearch.git
cd ~/tools/
echo "done"

echo "Installing virtual host discovery"
git clone https://github.com/jobertabma/virtual-host-discovery.git
cd ~/tools/
echo "done"

echo "Installing sqlmap"
git clone --depth 1 https://github.com/sqlmapproject/sqlmap.git sqlmap-dev
cd ~/tools/
echo "done"

echo "Installing knock.py"
git clone https://github.com/guelfoweb/knock.git
cd ~/tools/
echo "done"


echo "Installing massdns"
git clone https://github.com/blechschmidt/massdns.git
cd ~/tools/massdns
make
cd ~/tools/
echo "done"

echo "Installing asnlookup"
git clone https://github.com/yassineaboukir/asnlookup.git
cd ~/tools/asnlookup
pip3 install -r requirements.txt
cd ~/tools/
echo "done"

echo "Installing SubDomainizer"
git clone https://github.com/nsonaniya2010/SubDomainizer.git
cd ~/tools/SubDomainizer
pip3 install -r requirements.txt
cd ~/tools/
echo "done"

echo "Installing Subscraper"
git clone https://github.com/m8r0wn/subscraper
cd ~/tools/subscraper
pip3 install -r requirements.txt
cd ~/tools/
echo "done"

echo "Installing subfinder"
git clone https://github.com/projectdiscovery/subfinder.git
cd subfinder/cmd/subfinder
go build .
mv subfinder /usr/local/bin/
subfinder -h
cd ~/tools
echo "done"

echo "Installing httprobe"
go get -u github.com/tomnomnom/httprobe
echo "done"

echo "Installing meg"
go get -u github.com/tomnomnom/meg
echo "done"

echo "Installing unfurl"
go get -u github.com/tomnomnom/unfurl
echo "done"

echo "Installing waybackurls"
go get github.com/tomnomnom/waybackurls
echo "done"

echo "Downloading metabigor"
go get -u github.com/j3ssie/metabigor
echo "done"

echo "Installing crtndstry"
git clone https://github.com/nahamsec/crtndstry.git
echo "done"

echo "Downloading Seclists"
cd ~/tools/
git clone https://github.com/danielmiessler/SecLists.git
cd ~/tools/
echo "done"

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

# subzy, subjack, assetfinder
go get -u github.com/tomnomnom/assetfinder

go get -u github.com/jaeles-project/gospider

echo -e "\n\n\n\nDone! All tools are set up in ~/tools"
ls -la
