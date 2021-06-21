## GET PYASN section
## using https://github.com/ii/org/blob/main/research/asn-data-pipeline/etl_asn_vendor_table.org

## pyasn installs its utils in ~/.local/bin/*
## Add pyasn utils to path (dockerfile?)
## full list of RIB files on ftp://archive.routeviews.org//bgpdata/2021.05/RIBS/
cd /tmp
pyasn_util_download.py --latest
mv rib.*.*.bz2 rib.latest.bz2
## Convert rib file to .dat we can process
pyasn_util_convert.py --single rib.latest.bz2 ipasn_latest.dat
## Run the py script we are including in the docker image
python ./ii-pyasn.py

## Load csv into pg
## placeholder sql
create table pyasn_ip_asn  (ip cidr, asn int);
\COPY pyasn_ip_asn from '/home/ii/foo/pyAsnOutput.csv' DELIMITER ',' CSV;
## Split subnet into start and end
  select asn as asn,
  ip as ip,
  host(network(ip)::inet) as ip_start,
  host(broadcast(ip)::inet) as ip_end
  into table pyasn_ip_asn_extended
  from pyasn_ip_asn;

 ## Copy the results to cs
 \copy (select * from pyasn_ip_asn_extended) to '/tmp/pyasn_expanded_ipv4.csv' csv header;
 ## Load csv to bq
 bq load --autodetect k8s_artifacts_dataset_bb_test.pyasn_ip_asn_extended /tmp/pyasn_expanded_ipv4.csv
 ## Lets go convert the beginning and end into ints
   bq query --nouse_legacy_sql \
   '
   SELECT
     asn as asn,
     ip as cidr_ip,
     ip_start as start_ip,
     ip_end as end_ip,
     NET.IPV4_TO_INT64(NET.IP_FROM_STRING(ip_start)) AS start_ip_int,
     NET.IPV4_TO_INT64(NET.IP_FROM_STRING(ip_end)) AS end_ip
     from `k8s-infra-ii-sandbox.k8s_artifacts_dataset_bb_test.shadow_ip_asn_extended`
     WHERE regexp_contains(ip_start, r"^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}");
   '

## This should be the end of pyasn section, we have results table that covers start_ip/end_ip from fs our requirements
## GET k8s asn yaml using:
## https://github.com/ii/org/blob/main/research/asn-data-pipeline/asn_k8s_yaml.org
## Lets create csv's to import
## TODO: refactor this to loop that can generate these in a couple of passes
curl -s https://raw.githubusercontent.com/kubernetes/k8s.io/main/registry.k8s.io/infra/meta/asns/microsoft.yaml | yq e . -j - \
| jq -r '.name as $name | .redirectsTo.registry as $redirectsToRegistry | .redirectsTo.artifacts as $redirectsToArtifacts | .asns[] | [.,$name, $redirectsToRegistry, $redirectsToArtifacts] | @csv' > /tmp/microsoft_yaml.csv
curl -s https://raw.githubusercontent.com/kubernetes/k8s.io/main/registry.k8s.io/infra/meta/asns/google.yaml | yq e . -j - \
| jq -r '.name as $name | .redirectsTo.registry as $redirectsToRegistry | .redirectsTo.artifacts as $redirectsToArtifacts | .asns[] | [.,$name, $redirectsToRegistry, $redirectsToArtifacts] | @csv' > /tmp/google_yaml.csv
curl -s https://raw.githubusercontent.com/kubernetes/k8s.io/main/registry.k8s.io/infra/meta/asns/amazon.yaml | yq e . -j - \
| jq -r '.name as $name | .redirectsTo.registry as $redirectsToRegistry | .redirectsTo.artifacts as $redirectsToArtifacts | .asns[] | [.,$name, $redirectsToRegistry, $redirectsToArtifacts] | @csv' > /tmp/amazon_yaml.csv
curl -s https://raw.githubusercontent.com/kubernetes/k8s.io/main/registry.k8s.io/infra/meta/asns/alibabagroup.yaml | yq e . -j - \
| jq -r '.name as $name | .redirectsTo.registry as $redirectsToRegistry | .redirectsTo.artifacts as $redirectsToArtifacts | .asns[] | [.,$name, $redirectsToRegistry, $redirectsToArtifacts] | @csv' > /tmp/alibabagroup_yaml.csv
curl -s https://raw.githubusercontent.com/kubernetes/k8s.io/main/registry.k8s.io/infra/meta/asns/baidu.yaml | yq e . -j - \
| jq -r '.name as $name | .redirectsTo.registry as $redirectsToRegistry | .redirectsTo.artifacts as $redirectsToArtifacts | .asns[] | [.,$name, $redirectsToRegistry, $redirectsToArtifacts] | @csv' > /tmp/baidu_yaml.csv
curl -s https://raw.githubusercontent.com/kubernetes/k8s.io/main/registry.k8s.io/infra/meta/asns/digitalocean.yaml | yq e . -j - \
| jq -r '.name as $name | .redirectsTo.registry as $redirectsToRegistry | .redirectsTo.artifacts as $redirectsToArtifacts | .asns[] | [.,$name, $redirectsToRegistry, $redirectsToArtifacts] | @csv' > /tmp/digitalocean_yaml.csv
curl -s https://raw.githubusercontent.com/kubernetes/k8s.io/main/registry.k8s.io/infra/meta/asns/equinixmetal.yaml | yq e . -j - \
| jq -r '.name as $name | .redirectsTo.registry as $redirectsToRegistry | .redirectsTo.artifacts as $redirectsToArtifacts | .asns[] | [.,$name, $redirectsToRegistry, $redirectsToArtifacts] | @csv' > /tmp/equinixmetal_yaml.csv
curl -s https://raw.githubusercontent.com/kubernetes/k8s.io/main/registry.k8s.io/infra/meta/asns/huawei.yaml | yq e . -j - \
| jq -r '.name as $name | .redirectsTo.registry as $redirectsToRegistry | .redirectsTo.artifacts as $redirectsToArtifacts | .asns[] | [.,$name, $redirectsToRegistry, $redirectsToArtifacts] | @csv' > /tmp/huawei_yaml.csv
curl -s https://raw.githubusercontent.com/kubernetes/k8s.io/main/registry.k8s.io/infra/meta/asns/tencentcloud.yaml | yq e . -j - \
| jq -r '.name as $name | .redirectsTo.registry as $redirectsToRegistry | .redirectsTo.artifacts as $redirectsToArtifacts | .asns[] | [.,$name, $redirectsToRegistry, $redirectsToArtifacts] | @csv' > /tmp/tencentcloud_yaml.csv

## Load all the csv
## TODO: Make this into a loop.
## TODO: Set a final destination table
bq load --autodetect k8s_artifacts_dataset_bb_test.k8s_repo_json /tmp/microsoft_yaml.csv
bq load --autodetect k8s_artifacts_dataset_bb_test.k8s_repo_json /tmp/google_yaml.csv
bq load --autodetect k8s_artifacts_dataset_bb_test.k8s_repo_json /tmp/amazon_yaml.csv
bq load --autodetect k8s_artifacts_dataset_bb_test.k8s_repo_json /tmp/alibabagroup_yaml.csv
bq load --autodetect k8s_artifacts_dataset_bb_test.k8s_repo_json /tmp/baidu_yaml.csv
bq load --autodetect k8s_artifacts_dataset_bb_test.k8s_repo_json /tmp/digitalocean_yaml.csv
bq load --autodetect k8s_artifacts_dataset_bb_test.k8s_repo_json /tmp/equinixmetal_yaml.csv
bq load --autodetect k8s_artifacts_dataset_bb_test.k8s_repo_json /tmp/huawei_yaml.csv
bq load --autodetect k8s_artifacts_dataset_bb_test.k8s_repo_json /tmp/tencentcloud_yaml.csv

## GET Vendor YAML
## https://github.com/ii/org/blob/main/research/asn-data-pipeline/asn_k8s_yaml.org
curl 'https://download.microsoft.com/download/7/1/D/71D86715-5596-4529-9B13-DA13A5DE5B63/ServiceTags_Public_20210607.json' | jq -r \
'.values[] | .properties.platform as $service | .properties.region as $region | .properties.addressPrefixes[] | [., $service, $region] | @csv' > /tmp/microsoft_subnet_region.csv
curl 'https://www.gstatic.com/ipranges/cloud.json' | jq -r '.prefixes[] | [.ipv4Prefix, .service, .scope] | @csv' > /tmp/google_raw_subnet_region.csv
curl 'https://ip-ranges.amazonaws.com/ip-ranges.json' | jq -r '.prefixes[] | [.ip_prefix, .service, .region] | @csv' > /tmp/amazon_raw_subnet_region.csv

## Load all the csv
## TODO: Make this into a loop.
## TODO: Set a final destination table
bq load --autodetect k8s_artifacts_dataset_bb_test.amazon_raw_subnet_region /tmp/amazon_raw_subnet_region.csv
bq load --autodetect k8s_artifacts_dataset_bb_test.google_raw_subnet_region /tmp/google_raw_subnet_region.csv
bq load --autodetect k8s_artifacts_dataset_bb_test.microsoft_raw_subnet_region /tmp/microsoft_subnet_region.csv

## GET Metadata from peeringdb
## https://github.com/ii/org/blob/main/research/asn-data-pipeline/etl_asn_metadata_table.org
## In docker file section above, make sure credentials is set, psycopg2 is installed
## Import the schema from the repo
psql -U postgres -d peeringdb -h $SHARINGIO_PAIR_LOAD_BALANCER_IP < schema.sql
## Run the sync to populate the database
python3 ./sync.py
## Lets get a table with asns only
cat /home/ii/potaroo_company_asn.csv | cut -d ',' -f1 | sed 's/"//' | sed 's/"//'| cut -d 'S' -f2 >> asns_only.txt
## placeholder for sql we will need to import asn_only from
 create table asnproc (
       asn bigint not null primary key
 );
\copy asnproc from '/home/ii/autonums/asns_only.txt';
## Placeholder sql for joining peeringdb to produce output with email, website
  \copy ( select distinct asn.asn,
   (net.data ->> 'name') as "name",
   (net.data ->> 'website') as "website",
   (poc.data ->> 'email') as email
   into asn_name_web_email
   from asnproc asn
   left join peeringdb.net net on (net.asn = asn.asn)
   left join peeringdb.poc poc on ((poc.data ->> 'name') = (net.data ->> 'name'))
   -- where (net.data ->>'website') is not null
   -- where (poc.data ->> 'email') is not null
   order by email asc) to '/tmp/peeringdb_metadata.csv' csv header;;

## Load output to bq
bq load --autodetect k8s_artifacts_dataset_bb_test.amazon_raw_subnet_region /tmp/amazon_raw_subnet_region.csv
