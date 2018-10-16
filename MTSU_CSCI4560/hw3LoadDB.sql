

insert into hw3.supplier (Sno,Sname,Status,City) values ('s1','Smith','20','London');
insert into hw3.supplier (Sno,Sname,Status,City) values ('s2','Jones','10','Paris');
insert into hw3.supplier (Sno,Sname,Status,City) values ('s3','Blake','30','Paris');
insert into hw3.supplier (Sno,Sname,Status,City) values ('s4','Clark','20','London');
insert into hw3.supplier (Sno,Sname,Status,City) values ('s5','Adams','30',NULL);


insert into hw3.part (Pno,Pname,Color,Weight,City) values ('p1','Nut','Red','12','London');
insert into hw3.part (Pno,Pname,Color,Weight,City) values ('p2','Bolt','Green','17','Paris');
insert into hw3.part (Pno,Pname,Color,Weight,City) values ('p3','Screw',NULL,'17','Rome');
insert into hw3.part (Pno,Pname,Color,Weight,City) values ('p4','Screw','Red','14','London');
insert into hw3.part (Pno,Pname,Color,Weight,City) values ('p5','Cam','Blue','12','Paris');
insert into hw3.part (Pno,Pname,Color,Weight,City) values ('p6','Cog','Red','19','London');


insert into hw3.shipment (Sno,Pno,Qty,Price) values ('s1','p1','300','.005');
insert into hw3.shipment (Sno,Pno,Qty,Price) values ('s1','p2','200','.009');
insert into hw3.shipment (Sno,Pno,Qty,Price) values ('s1','p3','400','.004');
insert into hw3.shipment (Sno,Pno,Qty,Price) values ('s1','p4','200','.009');
insert into hw3.shipment (Sno,Pno,Qty,Price) values ('s1','p5','100','.01');
insert into hw3.shipment (Sno,Pno,Qty,Price) values ('s1','p6','100','.01');
insert into hw3.shipment (Sno,Pno,Qty,Price) values ('s2','p1','300','.006');
insert into hw3.shipment (Sno,Pno,Qty,Price) values ('s2','p2','400','.004');
insert into hw3.shipment (Sno,Pno,Qty,Price) values ('s3','p2','200','.009');
insert into hw3.shipment (Sno,Pno,Qty,Price) values ('s3','p3','200',NULL);
insert into hw3.shipment (Sno,Pno,Qty,Price) values ('s4','p2','200','.008');
insert into hw3.shipment (Sno,Pno,Qty,Price) values ('s4','p3',NULL,NULL);
insert into hw3.shipment (Sno,Pno,Qty,Price) values ('s4','p4','300','.006');
insert into hw3.shipment (Sno,Pno,Qty,Price) values ('s4','p5','400','.003');
