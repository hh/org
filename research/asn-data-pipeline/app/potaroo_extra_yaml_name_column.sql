## Potaroo data with extra column for yaml name
SELECT asn, companyname, name_yaml FROM ( SELECT asn, companyname FROM `${GCP_BIGQUERY_DATASET}.potaroo_all_asn_name`) A LEFT OUTER JOIN ( SELECT asn_yaml, name_yaml FROM `${GCP_BIGQUERY_DATASET}.vendor_yaml`) B ON A.asn=B.asn_yaml
