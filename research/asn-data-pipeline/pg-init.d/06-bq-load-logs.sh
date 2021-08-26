## Load logs to bq
if [ -z "${GCP_BIGQUERY_DATASET_LOGS:-}" ]; then
  echo "Using dataset logs, since \$GCP_BIGQUERY_DATASET_LOGS was provided and set to '$GCP_BIGQUERY_DATASET_LOGS'"
  bq load --autodetect --max_bad_records=2000 ${GCP_BIGQUERY_DATASET}_$(date +%Y%m%d).usage_all_raw gs://k8s-infra-artifacts-gcslogs/*
fi
