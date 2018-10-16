-- Ben Belden

-- Explanation of the data model:
/*
The RENTER table contains data on all of the people that have ever leased an apartment from RAD.
Renters in the RENTER table that do not have a lease are individuals that have been approved to
rent an apartment, but have not signed a lease yet. Each renter can have zero or more dependents
that live with them. Data on these people are kept in the DEPENDENT table. Data about the different
apartments are kept in the APARTMENT table. For each apartment, the apartment number, square footage, 
number of bedrooms, and the current monthly rent for that apartment are kept. The CURRENT monthly
rent is the amount that the RAD plans to charge for the next lease for that apartment. Whenever a 
renter signs a lease to occupy an apartment, data about that lease is kept in the LEASE table. Each
lease is for only one year. If a renter wishes to stay beond one year, then another one year lease 
must be signed. For each lease, the lease number, renter, apartment, beginning date of the lease, end
date of the lease, and the monthly rent that will be paid by the renter for that apartnemt are recorded.
The CURRENT rent for an apartment can change frequently, as the ownser's analyze the market to determine
the optimal rent price to charge next year, but a renter's monthly rent for a given apartment lease
cannot change until the current lease ends and a new lease is created. 
*/


-- CTAS commands
CREATE TABLE renter AS SELECT * FROM rad.renter;
CREATE TABLE lease AS SELECT * FROM rad.lease;
CREATE TABLE apartment AS SELECT * FROM rad.apartment;
CREATE TABLE dependent AS SELECT * FROM rad.dependent;


-- 1 --
/*
Write a query to display the renter ID, name, and number of different apartments that
have been rented by each renter. The renter name should be first and last name with a 
single space between them. Limit the results to only the renters born before January 1, 
1990. Be sure to include renters that have never rented any apartment. Sort the results
by the number of different apartments rented in descending order, then by the renter's
last name in ascending order.
*/
SELECT r.renter_id AS id,renter_fname||' '||renter_lname AS "Name",
rntd AS "Number of Apartments" FROM renter r
JOIN
(
  SELECT r.renter_id,Count(DISTINCT apart_num) AS rntd
  FROM renter r left JOIN lease l ON r.renter_id = l.renter_id
  GROUP BY r.renter_id
) t
  ON r.renter_id = t.renter_id
WHERE renter_dob < '01-JAN-90'
ORDER BY "Number of Apartments" DESC,renter_lname;


-- 2 --
/*
Write a query to display the apartment building, apartment number, square feet, current
rent, average of all rents ever charged for apartments in that building, and the difference
of the current rent minus the average rent ever charged for apartments in that building. 
Include only buildings that have had more than 3 different apartments in it that have ever
been rented. Sort the results in ascending order by the difference and then by the apartment
number.
*/
SELECT a.apart_building,apart_num,apart_sqft,apart_rent AS "NEXT LEASE RENT",
To_Char(avgrent,'9999.99') AS "AVERAGE RENT CHARGED FOR BUILDING",
To_Char(apart_rent-avgrent,'999.99') AS difference
FROM apartment a JOIN
(
    SELECT apart_building, Avg(lease_rent) AS avgrent
    FROM lease l JOIN apartment a ON a.apart_num = l.apart_num
    GROUP BY apart_building HAVING Count(DISTINCT a.apart_num) > 3
) t
ON t.apart_building = a.apart_building
ORDER BY apart_rent-avgrent,apart_num;


-- 3 --
/*
Write a query to display the renter ID, renter name, phone number, apartment number, and 
buildingfor all renters that had a lease that started July 1, 2016, but have not signed a 
lease that starts July 1, 2017. Also include renters that have never signed any lease. Display 
the renter name as the first and last name separated by a single space. Sort the results by 
renter last name and then first name.
*/
SELECT r.renter_id,renter_fname||' '||renter_lname AS name,
renter_phone AS phone,a.apart_num,apart_building AS building
FROM lease l JOIN apartment a ON l.apart_num = a.apart_num
     right JOIN renter r ON r.renter_id = l.renter_id
WHERE
(
  lease_begin = '01-JUL-16' AND l.renter_id NOT IN
  (
    SELECT renter_id FROM lease WHERE lease_begin = '01-JUL-17'
  )
)
OR
(
  r.renter_id NOT IN (SELECT DISTINCT renter_id FROM lease)
)
ORDER BY r.renter_lname,r.renter_fname
;


-- 4 --
/*
Write a query to display the renter ID, last name, and the bumber of people per bedroom
of the apartment. The people per bedroom is calculated as the renter plus the number of 
dependents associated with the renter, divided by the number of bedrooms in the apartment.
Remember, not all renters will have dependents, but the renter is still counted as a person.
Limit the results to only leases for apartments that end of June 30, 2018. Sort the results
by the number of perople per bedroom in descending order, then by renter ID in ascending order.
*/
SELECT r.renter_id,renter_lname,
To_Char(ttl/apart_bed,'9.99') AS "PEOPLE / BEDROOM" FROM renter r
JOIN
(
  SELECT r.renter_id,Count(d.renter_id) +1 AS ttl
  FROM renter r left JOIN dependent d ON r.renter_id = d.renter_id
  GROUP BY r.renter_id
) t
  ON r.renter_id = t.renter_id
  JOIN lease l ON r.renter_id = l.renter_id
  JOIN apartment a ON a.apart_num = l.apart_num
WHERE lease_end = '30-JUN-18'
ORDER BY "PEOPLE / BEDROOM" DESC,renter_id;


-- 5 --
/*
Write a query to display the renter ID, last name, lease begin date, end date, and the
total value of the lease. The total value of the lease is the lease rent multiplied by
12. Limit the results to leases that end on June 30, 2016, that are for apartments with 
more than 1 bedroom, and that have a total value of the lease that is greater than $10,500.
Sort the results by the total value of the lease and then by the renter's last name.
*/
SELECT r.renter_id,renter_lname,
  To_Char(lease_begin,'yyyy-mm-dd') AS "BEGIN DATE",
  To_Char(lease_end,'mm/dd/yyyy') AS "END DATE",
  To_Char(lease_rent * 12,'$99,999.99') AS leasetotal
FROM lease l  JOIN apartment a ON l.apart_num = a.apart_num
              JOIN renter r ON r.renter_id = l.renter_id
WHERE lease_end = '30-JUN-16' AND lease_rent * 12 > 10500 AND apart_bed > 1
ORDER BY leasetotal,renter_lname;


-- 6 --
/*
Write a query to display the renter name and phone number. Limit the results to renter
whose phone number is in the 615 area code, and that have never signed a lease. Display
the renters name as last namd and first name separated by a comma and a single space.
Sort the results by the phone number.
*/
SELECT renter_lname || ', ' || renter_fname AS "Name",renter_phone
FROM renter WHERE renter_id NOT IN
(
  SELECT DISTINCT renter_id FROM lease
)
AND renter_phone LIKE '615%'
ORDER BY renter_phone;


-- 7 --
/*
Write a query to display the apartment number, the monthly rent per square foot planned
for next year, and the average monthly rent per square foot for all leases of that
apartment that started before July 1, 2015. Sort the results by apartment number.
*/
SELECT a.apart_num,
To_Char(apart_rent / apart_sqft,'9.999') AS "Rent / SqFt Next Year",
To_Char(t.avrg,'9.999') AS "Rent / SqFt pre-2015"
FROM apartment a
JOIN
(
  SELECT l.apart_num,Avg(lease_rent / apart_sqft) AS avrg
  FROM lease l JOIN apartment a ON l.apart_num = a.apart_num
  WHERE lease_begin < '01-JUL-15' GROUP BY l.apart_num
) t
  ON a.apart_num = t.apart_num ORDER BY apart_num;


-- 8 --
/*
Write a query to return the renter ID, first name, last name, lease begin date, apartment
square footage, and the lease rent for all leases of apartments that either 
  1) started on July 1, 2017 and had a quare footage over 1000 squre feet, or
  2) started on July 1, 2016 and had either
    a) square footage over 900 square feet and lease rent less than $1000, or
    b) square footage over 1000 square feet and lease rent less than $1100.
Sort the results by lease begin date, square footage, and then by lease rent.
*/
SELECT r.renter_id,renter_fname,renter_lname,lease_begin,apart_sqft,lease_rent
FROM apartment a JOIN lease l ON a.apart_num = l.apart_num
JOIN renter r ON r.renter_id = l.renter_id
WHERE
(
  ( -- 1
    lease_begin = '01-JUL-17' AND apart_sqft > 1000
  )
  OR
  ( -- 2
    lease_begin = '01-JUL-16'
    AND
    (
      ( -- 2a
        apart_sqft > 900 AND lease_rent < 1000
      )
      OR
      ( -- 2b
        apart_sqft > 1000 AND lease_rent < 1100
      )
    )
  )
)
ORDER BY lease_begin,apart_sqft,lease_rent;


-- 9 --
/*
Write a query to display the renter ID, renter name (first and last separated with a 
space), lease begin date, renter's approximate age in years at the beginning of the lease,
and the renter's number of dependents. The renter's approximate age in years is calculated
by subtracting the renters date of birth from the lease begin date and then dividing by 
365. Limit the results to renters with more than 1 dependent. Sort the results by the renter's
approximate age in years at the beginning of the lease, the number of dependents, and then
by renter ID.
*/
SELECT r.renter_id, renter_fname || ' ' || renter_lname AS "Name",lease_begin,
To_Char((lease_begin - renter_dob)/365,'99') AS "Approx. Age (years)",
deps AS "Number Dependents"
FROM lease l JOIN renter r ON l.renter_id = r.renter_id
JOIN
(
  SELECT renter_id,Count(*) AS deps FROM dependent
  GROUP BY renter_id HAVING Count(*) > 1
) t
  ON r.renter_id = t.renter_id
ORDER BY "Approx. Age (years)","Number Dependents",renter_id;


-- 10 --
/*
Write a query to diplay the apartment number, building and number of bedrooms of 
apartments that have never been rented to a renter without dependents. Limit the results
to only apartments in buildings A or C. Sort the results by building and then by
apartment number.
*/
SELECT apart_num AS apartment,apart_building AS building,apart_bed AS bedrooms
FROM apartment WHERE apart_building IN ('A','C') AND apart_num NOT IN
( -- apartments leased to renters without dependents
  SELECT DISTINCT apart_num FROM lease WHERE renter_id IN
  ( -- renters without dependents
    SELECT renter_id FROM renter WHERE renter_id NOT IN
    ( -- renters with dependents
      SELECT DISTINCT renter_id FROM dependent
    )
  )
)
ORDER BY building,apartment;

