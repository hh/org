## Get single clientip as int.
envsubst < /app/join_all_the_things.sql | bq query --nouse_legacy_sql --replace --destination_table "${GCP_BIGQUERY_DATASET}.7_asn_company_c_ip_lookup"
