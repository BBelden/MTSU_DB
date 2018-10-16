-- 1. Print part numbers and names for all parts.
select pno, pname from hw3.part;

-- 2. Print part numbers for parts that either blue or red in color.
select pno from hw3.part where color in ('Red','Blue');

-- 3. Print all shipment information where the quantity is in the range 300 to 750 inclusive.
select * from hw3.shipment where qty between 300 and 750;

-- 4. Print supplier names for suppliers who ship P2 or P4.
select distinct sname from hw3.supplier s 
join hw3.shipment h on s.sno=h.sno where h.pno in ('p2','p4');

-- 5. Print supplier numbers for suppliers who ship at least all those parts shipped by supplier S3.  
--    Do not include S3 in the answer and do not 'count'.
select distinct sno from hw3.shipment s where s.sno !='s3' and not exists
(select pno from hw3.shipment h where sno = 's3' and pno not in
(select pno from hw3.shipment i where i.sno = s.sno));

-- 6. Print supplier numbers for suppliers who ship at least one type of red part.
select sno from hw3.supplier where sno in
(select s.sno from hw3.supplier s join hw3.shipment h on s.sno=h.sno 
join hw3.part p on h.pno=p.pno and color = 'Red');

-- 7. Print supplier numbers for suppliers who do not ship any red parts.
select sno from hw3.supplier where sno not in 
(select s.sno from hw3.supplier s join hw3.shipment h on s.sno=h.sno
join hw3.part p on h.pno=p.pno and color = 'Red');

-- 8. Print supplier numbers for suppliers who ship ONLY red parts.
select sno from hw3.supplier where sno in 
(select s.sno from hw3.supplier s join hw3.shipment h on s.sno=h.sno
join hw3.part p on h.pno=p.pno and color = 'Red')
and sno not in 
(select s.sno from hw3.supplier s join hw3.shipment h on s.sno=h.sno
join hw3.part p on h.pno=p.pno and color != 'Red');

-- 9. Print supplier names for suppliers who do not currently ship any parts.
select sname from hw3.supplier where sname not in (select s.sname from hw3.supplier s join hw3.shipment h on s.sno=h.sno);

-- 10. Print supplier names for suppliers who ship at least one part that is also shipped by supplier S2.  
--     Do not include S2 in the answer.
select sname from 
(select distinct h.sno from hw3.shipment h where h.pno in (select h.pno from hw3.shipment h where h.sno = 's2') and h.sno!='s2') r
join hw3.supplier s on s.sno=r.sno;

-- 11. Print the supplier information by cities in alphabetic order.
select * from hw3.supplier s order by city;

-- 12. Print the shipment information by price in descending numeric order.
select * from hw3.shipment h order by price desc;

-- 13. Print supplier numbers for suppliers who are located in the same city as supplier S1. 
--     Do not include S1 in the answer.
select sno from hw3.supplier where city=(select city from hw3.supplier where sno='s1') and sno != 's1';

-- 14. Print part numbers for all parts shipped by more than one supplier.  You may use a count on this one.
select h.pno from hw3.shipment h join hw3.part p on h.pno = p.pno group by h.pno having count(h.pno) > 1;

-- 15. Print supplier numbers for suppliers with status value less than the current average status value of all suppliers.
select sno from hw3.supplier where status < (select avg(status) from hw3.supplier); 

-- 16. Print the total number of suppliers (regardless of whether they are currently shipping any parts)..
select count(distinct sno) from hw3.supplier;

-- 17. Print the total number of suppliers currently shipping parts.
select count(distinct sno) from hw3.shipment;

-- 18. Print all the shipment information for the shipment(s) with the highest unit cost.
select * from hw3.shipment where price = (select max(price) from hw3.shipment);

-- 19. Print all the shipment information for the shipment(s) with the highest total cost.
select * from hw3.shipment where price*qty = (select max(price*qty) from hw3.shipment);

-- 20. Print all the supplier information for the supplier(s) making the most money.  
--     The supplier money is determined by the sum of all shipment cost.  
--     Each shipment cost is found by the number of units being shipped times the price per unit.
select s.* from 
(select sno, sum(qty*price) as ttl from hw3.shipment group by sno) as allTtls
join 
(select  max(ttl) as maxval from (select sno, sum(qty*price) as ttl from hw3.shipment group by sno) as a) as maxTtl
on allTtls.ttl=maxTtl.maxval
join hw3.supplier s on allTtls.sno=s.sno;


-- 21. For each supplier, print the supplier number and how many different parts shipped. 
--     For example, S1 6; S2 2, ...
select s.sno, count(s.sno) from hw3.supplier s join hw3.shipment h on s.sno=h.sno group by s.sno;

