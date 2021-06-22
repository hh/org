#!/bin/bash
set -x

gcloud auth activate-service-account "${GCP_SERVICEACCOUNT}" --key-file="${GOOGLE_APPLICATION_CREDENTIALS}"
## GET ASN_COMAPNY section
## using https://github.com/ii/org/blob/main/research/asn-data-pipeline/etl_asn_company_table.org
## This will pull a fresh copy, I prefer to use what we have in gs
# curl -s  https://bgp.potaroo.net/cidr/autnums.html | sed -nre '/AS[0-9]/s/.*as=([^&]+)&.*">([^<]+)<\/a> ([^,]+), (.*)/"\1", "\3", "\4"/p'  | head
# TODO: add if statement to do manual parsing if the gs file is not there

if [ ! -f "/tmp/potaroo_data.csv" ]; then
    gsutil cp gs://ii_bq_scratch_dump/potaroo_company_asn.csv  /tmp/potaroo_data.csv
fi

# Strip data to only return ASN numbers
cat /tmp/potaroo_data.csv | cut -d ',' -f1 | sed 's/"//' | sed 's/"//'| cut -d 'S' -f2 | tail +2 >> /tmp/potaroo_asn.txt

## GET PYASN section
## using https://github.com/ii/org/blob/main/research/asn-data-pipeline/etl_asn_vendor_table.org

## pyasn installs its utils in ~/.local/bin/*
## Add pyasn utils to path (dockerfile?)
## full list of RIB files on ftp://archive.routeviews.org//bgpdata/2021.05/RIBS/
cd /tmp
if [ ! -f "rib.latest.bz2" ]; then
  pyasn_util_download.py --latest
  mv rib.*.*.bz2 rib.latest.bz2
fi
## Convert rib file to .dat we can process
if [ ! -f "ipasn_latest.dat" ]; then
  pyasn_util_convert.py --single rib.latest.bz2 ipasn_latest.dat
fi
## Run the py script we are including in the docker image
python3 /app/ip-from-pyasn.py /tmp/potaroo_asn.txt ipasn_latest.dat /tmp/pyAsnOutput.csv
## This will output pyasnOutput.csv
