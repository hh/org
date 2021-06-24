

# Run the above sql to do some more transformations

## Get single clientip as int.
envsubst < /app/distinct_c_ip_count.sql | bq query --nouse_legacy_sql --replace --destination_table "${GCP_BIGQUERY_DATASET}.1_ip_count"
envsubst < /app/distinct_ip_int.sql | bq query --nouse_legacy_sql --replace --destination_table "${GCP_BIGQUERY_DATASET}.2_ip_int"
envsubst < /app/distinct_ipint_only.sql | bq query --nouse_legacy_sql --replace --destination_table "${GCP_BIGQUERY_DATASET}.2a_ip_int"
envsubst < /app/potaroo_extra_yaml_name_column.sql | bq query --nouse_legacy_sql --replace --destination_table "${GCP_BIGQUERY_DATASET}.3_potaroo_with_yaml_name_column"
envsubst < /app/potaroo_yaml_name_subbed.sql | bq query --nouse_legacy_sql --replace --destination_table "${GCP_BIGQUERY_DATASET}.4_potaroo_with_yaml_name_subbed"
envsubst < /app/vendor_with_company_name.sql | bq query --nouse_legacy_sql --replace --destination_table "${GCP_BIGQUERY_DATASET}.5_vendor_with_company_name"
