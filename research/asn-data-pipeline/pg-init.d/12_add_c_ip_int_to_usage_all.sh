envsubst < /app/add_c_ip_int_to_usage_all.sql | bq query --nouse_legacy_sql --replace --destination_table "${GCP_BIGQUERY_DATASET}.usage_all_raw_int"
