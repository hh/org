begin;

create table company_asn  (asn varchar, name varchar);
create table pyasn_ip_asn  (ip cidr, asn int);

commit;
