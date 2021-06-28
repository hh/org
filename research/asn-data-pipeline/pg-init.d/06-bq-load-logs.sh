

# Load Logs

## Load logs to bq
if [ -z "${GCP_BIGQUERY_DATASET_LOGS}" ]; then
  bq load --autodetect ${GCP_BIGQUERY_DATASET}.usage_all_raw gs://k8s-artifacts-gcslogs/us.artifacts.k8s-artifacts-prod.appspot.com_usage*
  ## Need to figure out why this ones fails
  bq load --autodetect --max_bad_records=2000 ${GCP_BIGQUERY_DATASET}.usage_all_raw gs://k8s-artifacts-gcslogs/k8s-artifacts-prod_usage*
  bq load --autodetect ${GCP_BIGQUERY_DATASET}.usage_all_raw gs://k8s-artifacts-gcslogs/k8s-artifacts-kind_usage*
  bq load --autodetect ${GCP_BIGQUERY_DATASET}.usage_all_raw gs://k8s-artifacts-gcslogs/k8s-artifacts-csi_usage*
  bq load --autodetect ${GCP_BIGQUERY_DATASET}.usage_all_raw gs://k8s-artifacts-gcslogs/k8s-artifacts-cri-tools_usage*
  bq load --autodetect ${GCP_BIGQUERY_DATASET}.usage_all_raw gs://k8s-artifacts-gcslogs/k8s-artifacts-cni_usage*
  bq load --autodetect ${GCP_BIGQUERY_DATASET}.usage_all_raw gs://k8s-artifacts-gcslogs/asia.artifacts.k8s-artifacts-prod.appspot.com_usage*
  bq load --autodetect ${GCP_BIGQUERY_DATASET}.usage_all_raw gs://k8s-artifacts-gcslogs/eu.artifacts.k8s-artifacts-prod.appspot.com_usage*
fi
