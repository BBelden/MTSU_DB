create schema hw3;
go

create table hw3.supplier (
	sno varchar(45) not null,
	sname varchar(45) null,
	status int null,
	city varchar(45) null,
	primary key(sno));
go

create table hw3.part(
	pno varchar(45) not null,
	pname varchar(45) null,
	color varchar(45) null,
	weight int null,
	city varchar(45) null,
	primary key(pno));
go

create table hw3.shipment(
	sno varchar(45) not null,
	pno varchar(45) not null,
	qty int null,
	price decimal(4,3) null,
	primary key(sno,pno));
go

alter table hw3.shipment
add constraint fk_ship_supply
foreign key (sno)
references hw3.supplier(sno);
go

alter table hw3.shipment
add constraint fk_ship_part
foreign key (pno)
references hw3.part(pno);
go