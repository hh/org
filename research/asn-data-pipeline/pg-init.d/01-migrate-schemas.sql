begin;

create table company_asn (
  asn varchar,
  name varchar
);
create table pyasn_ip_asn (
  ip cidr,
  asn int
);
create table asnproc (
  asn bigint not null primary key
);

create table peeriingdbnet (
  data jsonb
);

create table peeriingdbpoc (
  data jsonb
);

commit;
