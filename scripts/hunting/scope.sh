#!/bin/bash

# Combine domain result files into one big file
for file in `ls *domain_result*`
do
    cat $file >> temp_domains.txt
done

sort -u temp_domains.txt > all_domains.txt
rm temp_domains.txt
rm in_scope_domains.txt || echo "in_scope_domains.txt file does not exist!"

# Manipulate the scope file to turn to regular expression
# Loop through each requirement and filter out the ones in scope
for domain in $(sed -e 's/\./\\./g' -e 's/*/.+/g' -e 's/$/\$/' scopes)
do
    cat all_domains.txt | egrep $domain >> temp_domains.txt
done

cat temp_domains.txt | httprobe -c 100 > alive_domains.txt
rm temp_domains.txt
cat alive_domains.txt | awk -F '//' '{print $2}' > in_scope_domains.txt
rm alive_domains.txt
# cat asns.json | jq --raw-output 'to_entries[] | select(.value.Name|test("[Pp]ay[Pp]al.+")).key'
# cat temp.json | jq --raw-output 'to_entries[] | select(.value.Name|test("^twitch.+")) | "\(.key) \(.value.Name)"'