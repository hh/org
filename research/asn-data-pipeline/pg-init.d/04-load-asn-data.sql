copy asnproc from '/tmp/potaroo_asn.txt';
-- Placeholder sql for joining peeringdb to produce output with email, website
copy peeriingdbnet (data) from '/tmp/peeringdb-tables/net.json';
copy peeriingdbpoc (data) from '/tmp/peeringdb-tables/poc.json';
copy (
  select distinct asn.asn,
  (net.data ->> 'name') as "name",
  (net.data ->> 'website') as "website",
  (poc.data ->> 'email') as email
  into asn_name_web_email
  from asnproc asn
  left join peeriingnet net on (net.asn = asn.asn)
  left join peeriingpoc poc on ((poc.data ->> 'name') = (net.data ->> 'name'))
-- where (net.data ->>'website') is not null
-- where (poc.data ->> 'email') is not null
  order by email asc) to '/tmp/peeringdb_metadata.csv' csv header;;
