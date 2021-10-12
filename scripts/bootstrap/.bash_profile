#----- AWS -------

s3ls(){
aws s3 ls s3://$1
}

s3cp(){
aws s3 cp $2 s3://$1 
}

#---- Content discovery ----
thewadl(){ #this grabs endpoints from a application.wadl and puts them in yahooapi.txt
curl -s $1 | grep path | sed -n "s/.*resource path=\"\(.*\)\".*/\1/p" | tee -a ~/tools/dirsearch/db/yahooapi.txt
}

#----- recon -----
crtndstry(){
~/tools/crtndstry/crtndstry.sh $1
}

am(){ #runs amass passively and saves to json
amass enum --passive -d $1 -json $1.json
jq .name $1.json | sed "s/\"//g"| httprobe -c 60 | tee -a $1-domains.txt
}

certprobe(){ #runs httprobe on all the hosts from certspotter
curl -s https://crt.sh/\?q\=\%.$1\&output\=json | jq -r '.[].name_value' | sed 's/\*\.//g' | sort -u | httprobe | tee -a ./all.txt
}

mscan(){ #runs masscan
sudo masscan -p4443,2075,2076,6443,3868,3366,8443,8080,9443,9091,3000,8000,5900,8081,6000,10000,8181,3306,5000,4000,8888,5432,15672,9999,161,4044,7077,4040,9000,8089,443,744 $1
}

certspotter(){ 
curl -s https://certspotter.com/api/v0/certs\?domain\=$1 | jq '.[].dns_names[]' | sed 's/\"//g' | sed 's/\*\.//g' | sort -u | grep $1
} #h/t Michiel Prins

crtsh(){
curl -s https://crt.sh/?q\=%.$1\&output\=json | jq -r '.[].name_value' | sed 's/\*\.//g' | sort -u
}

certnmap(){
curl https://certspotter.com/api/v0/certs\?domain\=$1 | jq '.[].dns_names[]' | sed 's/\"//g' | sed 's/\*\.//g' | sort -u | grep $1  | nmap -T5 -Pn -sS -i - -$
} #h/t Jobert Abma

ipinfo(){
curl http://ipinfo.io/$1
}


#------ Tools ------
dirsearch(){ # runs dirsearch and takes host and extension as arguments
python3 ~/tools/dirsearch/dirsearch.py "$@" 
}

asnlookup(){ # runs dirsearch and takes host and extension as arguments
python3 ~/tools/asnlookup/asnlookup.py "$@" 
}

sqlmap(){
python3 ~/tools/sqlmap*/sqlmap.py "$@" 
}

ncx(){
nc -l -n -vv -p $1 -k
}

crtshdirsearch(){ #gets all domains from crtsh, runs httprobe and then dir bruteforcers
curl -s https://crt.sh/?q\=%.$1\&output\=json | jq -r '.[].name_value' | sed 's/\*\.//g' | sort -u | httprobe -c 50 | grep https | xargs -n1 -I{} dirsearch -u {} -e $2 -t 50 -b 
}

patator(){
python3 ~/tools/patator/patator.py "$@"
}

goldfish(){
python3 ~/tools/LazyTools/GoldFish/GoldFishCmd.py "$@"
}

joomscan(){
perl ~/tools/joomscan/joomscan.pl "$@"
}

export PATH=$PATH:~/go/bin

#  ~/go/bin/gospider -s "https://paypal.com/" -o output -c 10 -d 1
# SubDomainizer.py -u https://www.paypal.com -o paypal_subdomainizer.txt -gt <github_token> -g
# ~/go/bin/assetfinder -subs-only paypal.com
# python3 subscraper.py --enum 1 paypal.com -o /mnt/hgfs/Pentest/bug_bounty/paypal_subscraper.txt
# python3 EyeWitness.py -f in_scope_domains.txt -d /path
# subfinder -d freelancer.com -o output.txt
# cat hosts.txt | xargs -P10 -I % bash -c "{ python3 corsy.py -u % ; }"