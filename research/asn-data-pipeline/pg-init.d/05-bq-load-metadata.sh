## Load output to bq
tail +2 /tmp/peeringdb_metadata_prepare.csv > /tmp/peeringdb_metadata.csv

bq load --autodetect "${GCP_BIGQUERY_DATASET}.metadata" /tmp/peeringdb_metadata.csv asn:integer,name:string,website:string,email:string
