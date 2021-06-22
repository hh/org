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

create schema peeringdb;

create table peeringdb.org (
	id int not null,
	status text not null,
	data jsonb not null,
	created timestamptz not null,
	updated timestamptz not null,
	deleted timestamptz,
	primary key (id)
);

create table peeringdb.net (
	id int not null,
	org_id int not null,
	asn bigint not null,
	status text not null,
	data jsonb not null,
	created timestamptz not null,
	updated timestamptz not null,
	deleted timestamptz,
	primary key (id)
);

create table peeringdb.ix (
	id int not null,
	org_id int not null,
	status text not null,
	data jsonb not null,
	created timestamptz not null,
	updated timestamptz not null,
	deleted timestamptz,
	primary key (id)
);

create table peeringdb.fac (
	id int not null,
	org_id int not null,
	status text not null,
	data jsonb not null,
	created timestamptz not null,
	updated timestamptz not null,
	deleted timestamptz,
	primary key (id)
);

create table peeringdb.poc (
	id int not null,
	net_id int not null,
	status text not null,
	data jsonb not null,
	created timestamptz not null,
	updated timestamptz not null,
	deleted timestamptz,
	primary key (id)
);

create table peeringdb.ixlan (
	id int not null,
	ix_id int not null,
	status text not null,
	data jsonb not null,
	created timestamptz not null,
	updated timestamptz not null,
	deleted timestamptz,
	primary key (id)
);

create table peeringdb.ixpfx (
	id int not null,
	ixlan_id int not null,
	status text not null,
	data jsonb not null,
	created timestamptz not null,
	updated timestamptz not null,
	deleted timestamptz,
	primary key (id)
);

create table peeringdb.ixfac (
	id int not null,
	ix_id int not null,
	fac_id int not null,
	status text not null,
	data jsonb not null,
	created timestamptz not null,
	updated timestamptz not null,
	deleted timestamptz,
	primary key (id)
);

create table peeringdb.netfac (
	id int not null,
	net_id int not null,
	fac_id int not null,
	status text not null,
	data jsonb not null,
	created timestamptz not null,
	updated timestamptz not null,
	deleted timestamptz,
	primary key (id)
);

create table peeringdb.netixlan (
	id int not null,
	net_id int not null,
	ix_id int not null,
	ixlan_id int not null,
	status text not null,
	data jsonb not null,
	created timestamptz not null,
	updated timestamptz not null,
	deleted timestamptz,
	primary key (id)
);

commit;
