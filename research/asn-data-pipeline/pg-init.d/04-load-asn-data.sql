copy asnproc from '/tmp/potaroo_asn.txt';
-- Placeholder sql for joining peeringdb to produce output with email, website
copy (
  select distinct asn.asn,
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
