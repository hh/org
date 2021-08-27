for TABLE in $(bq ls ${GCP_BIGQUERY_DATASET}_$(date --date=yesterday +%Y%m%d) | awk '{print $1}' | tail +3 | xargs); do
    echo "Removing table '${GCP_BIGQUERY_DATASET}.$TABLE'"
    bq rm -f "${GCP_BIGQUERY_DATASET}.$TABLE";
    echo "Copying table '${GCP_BIGQUERY_DATASET}_20210810.$TABLE' to '${GCP_BIGQUERY_DATASET}.$TABLE'"
    bq cp --noappend_table --nono_clobber -f "${GCP_BIGQUERY_DATASET}_20210810.$TABLE" "${GCP_BIGQUERY_DATASET}.$TABLE";
done