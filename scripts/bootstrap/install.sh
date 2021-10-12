#!/bin/bash
sudo add-apt-repository -y ppa:longsleep/golang-backports
sudo apt -y update

sudo apt install -y net-tools
sudo apt install -y libcurl4-openssl-dev
sudo apt install -y libssl-dev
sudo apt install -y jq
sudo apt install -y ruby-full
sudo apt install -y libcurl4-openssl-dev libxml2 libxml2-dev libxslt1-dev ruby-dev build-essential libgmp-dev zlib1g-dev
sudo apt install -y build-essential libssl-dev libffi-dev python-dev
sudo apt install -y libmysqlclient-dev
sudo apt install -y python-setuptools
sudo apt install -y libldns-dev
sudo apt install -y python3-pip
sudo apt install -y python-pip
sudo apt install -y python-dnspython
sudo apt install -y git
sudo apt install -y rename
sudo apt install -y xargs
sudo apt install -y tmux
sudo apt install -y vim
sudo apt install -y curl
sudo apt install -y golang-go
sudo apt install -y openssh-server
sudo apt install -y openjdk-8-jdk openjdk-8-jre
sudo snap install amass

sudo systemctl enable ssh
sudo systemctl start ssh

# install common python3 libraries
pip3 install boto3 requests lxml ipparser

echo "Installing bash_profile aliases from recon_profile"
cat .bash_profile >> ~/.bash_profile
source ~/.bash_profile
echo "source ~/.bash_profile" >> ~/.bashrc
echo "done"

# Setting up tmux
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
tmux source ./bbht/.tmux.conf
# echo "tmux source ~/.tmux.conf" >> ~/.bashrc

#Don't forget to set up AWS credentials!
echo "Don't forget to set up AWS credentials!"
sudo apt install -y awscli

#create a tools folder in ~/
mkdir ~/tools
cd ~/tools/

#install GoldFish
echo "Installing GoldFish"
git clone https://github.com/eRaMvn/LazyTools.git
cd ~/tools/
echo "done"

#install patator
echo "Installing Patator"
git clone https://github.com/lanjelot/patator
cd patator
sudo python3 setup.py install
cd ~/tools/
echo "done"

#install aquatone
echo "Installing Aquatone"
go get github.com/michenriksen/aquatone
echo "done"

#install eyewitness
echo "Installing EyeWitness"
git clone https://github.com/FortyNorthSecurity/EyeWitness.git
cd EyeWitness
cd setup
sudo ./setup.sh
cd ~/tools/
echo "done"

echo "Installing JSParser"
git clone https://github.com/nahamsec/JSParser.git
cd JSParser
sudo python setup.py install
cd ~/tools/
echo "done"

echo "Installing Sublist3r"
git clone https://github.com/aboul3la/Sublist3r.git
cd Sublist3r
pip install -r requirements.txt
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

echo "Installing lazys3"
git clone https://github.com/nahamsec/lazys3.git
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

echo "Installing lazyrecon"
git clone https://github.com/nahamsec/lazyrecon.git
cd ~/tools/
echo "done"

echo "Installing nmap"
sudo apt install -y nmap
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
cd ~/tools/SecLists/Discovery/DNS/
##THIS FILE BREAKS MASSDNS AND NEEDS TO BE CLEANED
cat dns-Jhaddix.txt | head -n -14 > clean-jhaddix-dns.txt
cd ~/tools/
echo "done"

echo "Downloading Jenkins"
wget -q -O - https://pkg.jenkins.io/debian/jenkins.io.key | sudo apt-key add -
sudo sh -c 'echo deb https://pkg.jenkins.io/debian binary/ > \
    /etc/apt/sources.list.d/jenkins.list'
sudo apt-get update
sudo apt-get install jenkins
ufw allow 8080

# subzy, subjack, assetfinder
go get -u github.com/tomnomnom/assetfinder

go get -u github.com/jaeles-project/gospider

echo -e "\n\n\n\n\n\n\n\n\n\n\nDone! All tools are set up in ~/tools"
ls -la
