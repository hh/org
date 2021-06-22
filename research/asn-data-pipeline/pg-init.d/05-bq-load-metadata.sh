## Load output to bq
bq load --autodetect "${GCP_BIGQUERY_DATASET}.metadata" <(tail +2 /tmp/peeringdb_metadata.csv) asn:integer,name:string,website:string,email:string
