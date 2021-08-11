

# Load ASN data with company names into BigQuery

## Load output to bq
tail +2 /tmp/peeringdb_metadata_prepare.csv > /tmp/peeringdb_metadata.csv

bq load --autodetect "${GCP_BIGQUERY_DATASET}_$(date +%Y%m%d).metadata" /tmp/peeringdb_metadata.csv asn:integer,name:string,website:string,email:string
