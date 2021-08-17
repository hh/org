## Load logs to bq
if [ -z "${GCP_BIGQUERY_DATASET_LOGS:-}" ]; then
  echo "Using dataset logs, since \$GCP_BIGQUERY_DATASET_LOGS was provided and set to '$GCP_BIGQUERY_DATASET_LOGS'"
  bq load --autodetect ${GCP_BIGQUERY_DATASET}_$(date +%Y%m%d).usage_all_raw gs://k8s-infra-artifacts-gcslogs/us.artifacts.k8s-artifacts-prod.appspot.com_usage*
  ## Need to figure out why this ones fails
  bq load --autodetect --max_bad_records=2000 ${GCP_BIGQUERY_DATASET}_$(date +%Y%m%d).usage_all_raw gs://k8s-infra-artifacts-gcslogs/k8s-artifacts-prod_usage*
  bq load --autodetect ${GCP_BIGQUERY_DATASET}_$(date +%Y%m%d).usage_all_raw gs://k8s-infra-artifacts-gcslogs/k8s-artifacts-kind_usage*
  bq load --autodetect ${GCP_BIGQUERY_DATASET}_$(date +%Y%m%d).usage_all_raw gs://k8s-infra-artifacts-gcslogs/k8s-artifacts-csi_usage*
  bq load --autodetect ${GCP_BIGQUERY_DATASET}_$(date +%Y%m%d).usage_all_raw gs://k8s-infra-artifacts-gcslogs/k8s-artifacts-cri-tools_usage*
  bq load --autodetect ${GCP_BIGQUERY_DATASET}_$(date +%Y%m%d).usage_all_raw gs://k8s-infra-artifacts-gcslogs/k8s-artifacts-cni_usage*
  bq load --autodetect ${GCP_BIGQUERY_DATASET}_$(date +%Y%m%d).usage_all_raw gs://k8s-infra-artifacts-gcslogs/asia.artifacts.k8s-artifacts-prod.appspot.com_usage*
  bq load --autodetect ${GCP_BIGQUERY_DATASET}_$(date +%Y%m%d).usage_all_raw gs://k8s-infra-artifacts-gcslogs/eu.artifacts.k8s-artifacts-prod.appspot.com_usage*
fi
