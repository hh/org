

# Formatting the data

#!/bin/bash

SKIP_TO=$1
READ_FROM=asns.txt
WRITE_TO=asn-data.csv

TMPDIR=$(mktemp -d)
echo "Temp folder: $TMPDIR"

ALLOWED_RETRIES=5

count=0
while IFS= read -r asn; do
    count=$((count+=1))
    retries=0
    echo "ASN[$count]: $asn"
    if [ $asn -eq 0 ] || ( [ ! -z $SKIP_TO ] && [ $count -lt $SKIP_TO ] ); then
        echo "Skipping [$count] $asn"
        continue
    fi
    until curl "https://api.bgpview.io/asn/$asn" 2> /dev/null > $TMPDIR/$asn.json && cat $TMPDIR/$asn.json | jq .data.name 2>&1 > /dev/null; do
        retries=$((retries+=1))
        if [ $retries -eq $ALLOWED_RETRIES ]; then
            echo "Skipping [$count] $asn"
            retries=0
            continue 2
        fi
        echo "Failed [$retries/$ALLOWED_RETRIES]. Retrying '$asn' in 3 seconds"
        sleep 3s
    done
    cat $TMPDIR/$asn.json | jq -r '.data | (.email_contacts | join(";")) as $contacts | .description_short as $name | [.asn, $name, $contacts] | @csv' 2> /dev/null \
        | tee -a $WRITE_TO 2>&1 > /dev/null
    sleep 1s
done < $READ_FROM
