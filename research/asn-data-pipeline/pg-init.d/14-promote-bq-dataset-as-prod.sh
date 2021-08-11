# bq rm -r -f "${GCP_BIGQUERY_DATASET}_$(date +%Y%m%d)"
for TABLE in $(bq ls etl_script_generated_set_20210810 | awk '{print $1}' | tail +3 | xargs); do
    bq cp -f "${GCP_BIGQUERY_DATASET}_20210810.$TABLE" "${GCP_BIGQUERY_DATASET}.$TABLE"
done
