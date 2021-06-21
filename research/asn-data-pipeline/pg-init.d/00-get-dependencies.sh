# main shell

#!/bin/bash
set -x

gcloud auth activate-service-account "${GCP_SERVICEACCOUNT}" --key-file="${GOOGLE_APPLICATION_CREDENTIALS}"
## GET ASN_COMAPNY section
## using https://github.com/ii/org/blob/main/research/asn-data-pipeline/etl_asn_company_table.org
## This will pull a fresh copy, I prefer to use what we have in gs
# curl -s  https://bgp.potaroo.net/cidr/autnums.html | sed -nre '/AS[0-9]/s/.*as=([^&]+)&.*">([^<]+)<\/a> ([^,]+), (.*)/"\1", "\3", "\4"/p'  | head
# TODO: add if statement to do manual parsing if the gs file is not there
gsutil cp gs://ii_bq_scratch_dump/potaroo_company_asn.csv  /tmp/potaroo.csv
