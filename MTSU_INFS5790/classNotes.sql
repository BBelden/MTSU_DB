/********************************** 20180321 **********************************/





SELECT
customer.cus_fname || ' ' || customer.cus_lname AS "Customer",invoice.inv_number AS "Invoice",invoice.inv_date AS "Purchase Date"
FROM customer, invoice where customer.cus_code = invoice.cus_code;


SELECT
customer.cus_fname || ' ' || customer.cus_lname AS "Customer",invoice.inv_number AS "Invoice",invoice.inv_date AS "Purchase Date"
FROM customer JOIN invoice ON customer.cus_code = invoice.cus_code;


SELECT DISTINCT cus_fname, cus_lname, cus_balance
FROM customer JOIN invoice ON customer.cus_code = invoice.cus_code;


SELECT vendor.v_code, vendor.v_name, product.p_code, product.p_descript
FROM product JOIN vendor ON product.v_code = vendor.v_code;


SELECT *
FROM product JOIN vendor USING (v_code);


SELECT *
FROM product
ORDER BY v_code, p_price;


SELECT c.cus_code, c.cus_fname, c.cus_lname, c.cus_balance
FROM customer c
WHERE c.cus_balance > 0;


SELECT *
FROM product p
WHERE p.p_price > 40 AND p.p_qoh < 20;


SELECT *
FROM product p
WHERE p.v_code = 24288 OR p.v_code = 25595;


SELECT *
FROM product p
WHERE p.p_price BETWEEN 10 AND 20;
-- same as --
WHERE p.p_price >= 10 AND p.price <= 20;





/********************************** 20180326 **********************************/





SELECT PRODUCT.P_CODE, P_DESCRIPT AS "DESCRIPTION", P_DISCOUNT, INV_NUMBER, LINE_NUMBER, LINE_PRICE*LINE_UNITS AS "LINE TOTAL"
FROM PRODUCT LEFT JOIN LINE ON PRODUCT.P_CODE = LINE.P_CODE
WHERE P_DISCOUNT= 0
ORDER BY "LINE TOTAL";


------------------------------special operators
--- IN (FIND VALUE IN LIST) -- the 'text' is case sensitive
SELECT *
FROM VENDOR
WHERE V_STATE IN ('TN', 'AL', 'KY');

---  this yeilds the same results as above, you have to have complete criteria each time, you can't just list the values (i.e., v_state=)
SELECT *
FROM VENDOR
WHERE V_STAETE = 'tn' OR V_STATE = 'AL' OR V_STATE = 'KY';

--- LIKE (substring seach) -- small piece of text inside a small piece of text -- % is a wild card - it means 0 or characters
--- search function of the database
SELECT *
FROM PRODUCT
WHERE P_DESCRIPT LIKE '%blade%';

--- this means that hammer is not the entire value you are looking for; here we are allowing other characters before and after
SELECT *
FROM PRODUCT
WHERE P_DESCRIPT LIKE '%hammer%';

--- this is the entire value you are looking for -- no wild cards involved - don't use like or wild cards when you are looking for a complete/exact value
SELECT *
FROM PRODUCT
WHERE P_CODE = '11QER/31';

--- all product descriptions that begin with S
SELECT*
FROM Product
WHERE P_DESCRIPT LIKE 'S%';

--- oracle is not case sensitive? but treat it like it is so we know how to use others
--- Upper and Lower converts to upper/lower case letters
--- Do not use upper/lower on numeric values
SELECT Lower(P_CODE), Upper (P_DESCRIPT)
FROM product
WHERE Upper(P_DESCRIPT) LIKE '%CLAW%';

SELECT *
FROM PRODUCT;

--- where there is no value/null in a certain column special operator is 'is null' has to complete to find the null fields
SELECT *
FROM PRODUCT
WHERE V_CODE IS NULL;

--- empty string - Oracle treats nulls the same as empty strings. You can do this but not for this class
SELECT *
FROM PRODUCT
WHERE V_CODE  = '';

---------------------------------beginning the inverse of the previous
--- not between
SELECT*
FROM product
WHERE p_price NOT BETWEEN 10 AND 20;

--- not in
SELECT *
FROM vendor
WHERE v_state not IN ('TN', 'AL', 'KY');

--- not like
SELECT *
FROM product
WHERE Upper (p_descript) NOT LIKE '%HAMMER%';

--- is not null
SELECT *
FROM product
WHERE v_code IS NOt NULL;


-------------------------------------------aggregate funcitons
--- takes a collection of rows and reduces it to a single row
--- five common: count, sum, average, min, max (will be responsible for these)

SELECT Avg(p_price)
FROM product;

--- count is only one tht you can use a * -- just counts the rows
SELECT Count(*)
FROM product;

--- this is give you 16
SELECT Count(p_code)
FROM product;

--- you get 14 here because there are 4 nulls.  count does not count the nulls
SELECT Count (v_code)
FROM product;

----distinct lists v_code only once, adding count gives you the number of different values
SELECT DISTINCT Count(v_code)
FROM product;

--- count does not count nulls as values
SELECT Count(distinct v_code)
FROM product;

SELECT Avg (p_price)
FROM product;

SELECT Sum(p_qoh)
FROM product;

SELECT Min(p_price), Max(p_price)
FROM product;





/********************************** 20180328 **********************************/




-- review
-- customers who's balance = 0
SELECT Count(*) AS "Zero Balance"
FROM customer
WHERE cus_balance = 0;

-- how many customers placed order
SELECT Count(DISTINCT cus_code) AS "Customers"
FROM invoice;

-- largest customer balance and average customer balance, formatted as currency
SELECT  To_Char(Max(cus_balance),'$999.99') AS "Largest Balance",
        To_Char(Avg(cus_balance),'$999.99') AS "Average Balance"
FROM customer;


-- class stuff
/*
    to_char
    change date formatting:
        mm, mon, month, dd, yy, yyyy
*/
SELECT p_code, p_descript, To_Char(p_indate,'mm/dd/yyyy')
FROM product;

-- aggregate functions: count, sum, avg, max, min
-- group by
SELECT v_code, Avg(p_price) AS AvgPrice, Count(*)
FROM product
GROUP BY v_code;

/*
    SQL code written/syntax order:
    select, from, where, group by, having, order by

    SQL code apparent execution order:
    from, where, group by, having, select, order by
*/

-- for example
SELECT p_code, p_descript, p_price * p_qoh AS total
FROM product
WHERE p_price * p_qoh > 40  -- can't use "total" because "select" hasn't executed
ORDER BY p_price * p_qoh;  -- or "total"

SELECT v_code, Avg(p_price) AS avgprice
FROM product
WHERE Avg(p_price) > 20  -- "where" CANNOT contain aggregate functions
GROUP BY v_code;            -- keeps/eliminates ROWS based on criteria
-- instead, do:
SELECT v_code, Round(Avg(p_price),2) AS avgprice
FROM product
GROUP BY v_code
HAVING Avg(p_price) > 20 ;  -- "having" CAN contain aggregate functions
                              -- keeps/eliminates GROUPS based on criteria

SELECT v_code, Sum(p_qoh) AS qoh, to_char(Round(Avg(p_price),2),'$999.99') AS avgprice, Count(*) AS products
FROM product
GROUP BY v_code           -- "group by" is an AND logical expression
ORDER BY v_code desc;

SELECT vendor.v_code, v_name, Count(p_code) AS numprods
FROM product JOIN vendor ON product.v_code = vendor.v_code
GROUP BY vendor.v_code, v_name;

SELECT v_state, Count(p_code) AS numprods
FROM product p JOIN vendor v ON v.v_code = p.v_code
GROUP BY v_state;

-- practice through 50




/********************************** 20180402 **********************************/




/*
  review
*/

SELECT v_code, p_qoh, Avg(p_price) AS avgprice
FROM product
GROUP BY v_code, p_qoh;

SELECT vendor.v_code, v_name, v_state, Avg(p_price) AS avgprice
FROM product JOIN vendor ON product.v_code = vendor.v_code
GROUP BY vendor.v_code, v_name, v_state;

/*
  end review
*/



-- using subqueries --

-- uncorrelated subqueries --
-- embedded select: FROM and WHERE

-- WHERE
  -- why? to navigate around aggregate function problems
  -- ex.
SELECT p_code, p_descript, p_price
FROM product
WHERE p_price > Avg(p_price); -- not the place for HAVING, so what do we do?
  -- better to embed this subquery
SELECT Avg(p_price) FROM product;
  -- like dis!
SELECT p_code, p_descript, p_price
FROM product
WHERE p_price > (SELECT Avg(p_price) FROM product);

  -- let's practice some!
SELECT p_code, p_descript
FROM product JOIN vendor ON vendor.v_code = product.v_code
WHERE v_state = 'TN';
  -- oooorrrrr
SELECT p_code, p_descript FROM product WHERE v_code in
  (SELECT v_code FROM vendor WHERE v_state = 'TN');
  -- WHERE subquery can also be a suitable substitute for a JOIN in certain circumstances


-- FROM
  -- using the results of a subquery table to do stuff on
SELECT avgprice, v_code
FROM (
  SELECT v_code, Round(Avg(p_price),2) AS avgprice
  FROM product
  GROUP BY v_code) T
WHERE avgprice < 50;


  -- remember, dis bad!!
SELECT v_code, p_qoh, Avg(p_price) AS avgprice
FROM product
GROUP BY v_code, p_qoh;
  -- dis better!
SELECT product.v_code, p_qoh, avgprice
FROM product  JOIN
                (SELECT v_code, Avg(p_price) AS avgprice
                 FROM product GROUP BY v_code) T
              ON product.v_code = T.v_code
ORDER BY product.v_code;

  -- another "more elaborate" example
SELECT p_code, p_descript, p_price, product.v_code, avgprice, p_price - avgprice AS diff
FROM product  JOIN
              (
                SELECT v_code, Round(Avg(p_price),2) AS avgprice
                FROM product
                GROUP BY v_code
              ) T
              ON product.v_code = T.v_code
WHERE p_price - avgprice > 0
ORDER BY p_code;


  -- to get an aggregate of an aggregate --
SELECT Max(avgprice)
FROM
(
  SELECT v_code, Round(Avg(p_price),2) AS avgprice
  FROM product
  GROUP BY v_code
);



/*
  this ends the SELECT portion of the class.
  finish the practice packet
*/


DROP TABLE member;
CREATE TABLE member
(
  mem_num     NUMBER                ,   -- oracle uses NUMBER, others use NUMERIC,INTEGER,DECIMAL,FLOAT, etc
  mem_lname   VARCHAR2(15) NOT NULL ,   -- varchar2 vs varchar because oracle
  mem_fname   VARCHAR2(15) NOT NULL ,      -- vc2 treats NULLs and empty strings as the same
  mem_street  VARCHAR(35)           ,      -- but oracle converts all vc to vc2 anyway, so neener
  mem_city    VARCHAR(35)           ,
  mem_state   CHAR(2) DEFAULT 'TN'  ,
  mem_zip     CHAR(5)               ,
  CONSTRAINT member_mem_num_pk PRIMARY KEY (mem_num)  -- could have used the PRIMARY KEY attribute constraint
);                                                    -- table constraints are required for composite keys
SELECT * FROM member;
SELECT * FROM user_tables;

DROP TABLE account;
CREATE TABLE account
(
  acc_num       VARCHAR(7) PRIMARY KEY                ,
  acc_opendate  DATE DEFAULT SYSDATE                  ,
  acc_balance   NUMBER(10,2)                          ,  -- 10 digits total, 2 to the right of the decimal
  acc_limit     NUMBER(10,2) DEFAULT 5000 NOT NULL    ,
  mem_num       NUMBER NOT NULL                       ,  -- forces mandatory participation
  CONSTRAINT account_mem_num_fk FOREIGN KEY (mem_num) REFERENCES member
);
SELECT * FROM account;





/********************************** 20180404 **********************************/





INSERT INTO member VALUES (101,'Johnson','Joe','101 Main Street','Murfreesboro','TN','37132');

INSERT INTO member (mem_lname,mem_num,mem_fname) VALUES ('Smith',102,'John');

DELETE FROM member WHERE mem_num = 102;



-- alter table --
  -- to modify an existing column, use MODIFY
ALTER TABLE account MODIFY acc_balance DEFAULT 0 NOT NULL;

  -- to modify the table, use ADD
ALTER TABLE account ADD CONSTRAINT account_bal_limit_ck CHECK (acc_balance <= acc_limit);


INSERT INTO account (acc_num,mem_num) VALUES ('1234567',101);
INSERT INTO account (acc_num,acc_balance,mem_num) VALUES ('2345678',NULL,102);        -- error --
INSERT INTO account (acc_num,acc_opendate,mem_num) VALUES ('2345678','01-mar-10',102);
  -- to format dates in an insert statement
    -- to_date(what_to_convert, format_mask)   -- like to_char()  in queries
INSERT INTO account (acc_num,acc_opendate,mem_num) VALUES ('3456789',To_Date('05/01/11','yy/mm/dd'),101);


UPDATE account SET acc_balance = 500 WHERE acc_num = '1234567';
UPDATE account SET acc_balance = acc_balance + 100 WHERE mem_num = 101;

COMMIT;  -- end of a transaction
ROLLBACK;  -- undo the transaction back to the last commit

SELECT * FROM account;





/**************************** 20180409 ****************************************/





-- DDL (create, alter, drop)
-- more DML  (insert, update, delete)
-- DELETE will remove a row that meets criteria
DELETE FROM account  -- if you stop here, all rows in the table will go bye bye
WHERE acc_num = '2345678';   -- removes the specific row
 -- can ROLLBACK to "undo" a DELETE



-- sequences
  -- unlike auto number, is not a data type, not associated with any table
  -- is a number generator
  -- best practices says should have a separate sequence for each column
SELECT Max(v_code) FROM vendor;

CREATE SEQUENCE v_code_seq
START WITH 25596
INCREMENT BY 1
NOCACHE;                -- because cis server is lame

SELECT * FROM user_sequences;

DROP SEQUENCE v_code_seq;

SELECT * FROM vendor;

-- how to use the sequence to generate a new value: sequence_name.nextval
  -- primary key
INSERT INTO vendor VALUES (v_code_seq.NEXTVAL,'stuff','things','123','234-3456','MI','N');
  -- be sure to enforce entity integrity on the natural key
  -- not done here as an example

-- using sequence to retrieve last used value: sequence_name.currval
  -- foreign key
  -- uses sessions to give YOU that value
  -- only "works" when .nextval is used in the session
INSERT INTO product VALUES ('123','Saw Blade',SYSDATE,10,5,15.99,0,v_code_seq.currval,0);

SELECT * FROM product;




/********************************* PL SQL *************************************/



BEGIN
  Dbms_Output.put_line('hello world!');
END;
/

-- simple block: BEGIN ... END;/
-- the / ends the program of commands, must be at the extreme left

-- create and manipulate variables
-- variable names are NOT case sensitive
DECLARE
  num1 NUMBER(1,0);   -- data types are same as used in database
BEGIN
  num1 := 3;
  num1 := num1 + 2;
  Dbms_Output.put_line('num1 is ' || num1);
END;
/

DECLARE
  num1 NUMBER(1);            -- if no second value, assume 0
  num2 NUMBER(4,1) := 20.1;  -- can initialize variables at declaration
  total NUMBER(6,1);            -- look up error trapping later
BEGIN
  num1 := 5;
  total := num1 * num2;
  IF num1 = 5 THEN
    Dbms_Output.put_line('num1 is 5');
  END IF;
  IF total < 100 THEN
    Dbms_Output.put_line('total less than 100');
  ELSE   -- if "NOT TRUE" not "FALSE", because T,F,UNK
    Dbms_Output.put_line('total not less than 100');
  END IF;
  Dbms_Output.put_line('the total = ' || total);
END;
/


DECLARE
  num1 NUMBER(1) := 5;
  num2 NUMBER(4,1) := 120.1;
  mytotal NUMBER(6,1);
BEGIN
  mytotal := num1 * num2;
  IF mytotal < 100 THEN
    Dbms_Output.put_line('total is small');
  ELSIF mytotal BETWEEN 100 AND 1000 THEN
    Dbms_Output.put_line('total is medium small');
  ELSIF mytotal BETWEEN 1000 AND 5000 THEN
    Dbms_Output.put_line('total is medium large');
  ELSE
    Dbms_Output.put_line('total is large');
  END IF;
  Dbms_Output.put_line('total is ' || mytotal);
END;
/




/**************************** 20180411 ****************************************/





/******* in PL/SQL:
    elsif == else if {}
    else if == else { if {} }
*******/

-- don't do loops like this, it's just for the people who don't know loops
DECLARE
    mycounter NUMBER(2) := 0;
BEGIN
  LOOP
    mycounter := mycounter+1;
    Dbms_Output.put_line('The value is: '||mycounter);
    IF mycounter = 20 THEN
      EXIT;
    END IF;
  END LOOP;
END;
/

-- exit when loop
DECLARE
  mycounter NUMBER(2) := 0;
BEGIN
  LOOP
    mycounter := mycounter+1;
    Dbms_Output.put_line('counter = '||mycounter);
    EXIT WHEN mycounter = 20;
    Dbms_Output.put_line('still in loop');
  END LOOP;
  Dbms_Output.put_line('out of the loop');
END;
/

DECLARE
  price product.p_price%type;     -- %type looks up the datatype of the attribute in the dbms and
  qty product.p_qoh%type;            -- makes the variable the same datatype
  total NUMBER(10,2);
BEGIN
  -- 11QER/31
  -- SELECT ... INTO ...      is the only way to get the data into a variable
  SELECT p_price,p_qoh INTO price,qty FROM product WHERE p_code = '11QER/31';
  total := price * qty;
  Dbms_Output.put_line('price: '||price);
  Dbms_Output.put_line('qoh: '||qty);
  Dbms_Output.put_line('total: '||to_char(total,'$9,999.99'));
END;
/

--             OOOOOOOOOOOOOOORRRRRRRRRRRRRRRRRR
--   https://docs.oracle.com/cd/B28359_01/appdev.111/b28370/rowtype_attribute.htm#LNPLS01342
DECLARE
  prodrow product%ROWTYPE;
  total NUMBER(10,2);
BEGIN
  SELECT * INTO prodrow FROM product WHERE p_code = '11QER/31';
  total := prodrow.p_price * prodrow.p_qoh;
  Dbms_Output.put_line(prodrow.p_price||' * '||prodrow.p_qoh);
  Dbms_Output.put_line('total: '||total);
END;
/

 --   http://www.oracle.com/technetwork/issue-archive/2013/13-mar/o23plsql-1906474.html  --
DECLARE
  -- like declaring the pointer
  CURSOR prod_c IS SELECT p_code,p_descript,p_price,p_qoh FROM product ORDER BY p_code;
  prodrow prod_c%ROWTYPE;
  total NUMBER(10,2);
BEGIN
  OPEN prod_c;  -- executes select query, allocate memory, pointer at first row
  LOOP
    FETCH prod_c INTO prodrow;  -- gets current row and advances the pointer
    EXIT WHEN prod_c%NOTFOUND;  -- or
    --EXIT WHEN prod_c%FOUND = FALSE;
    total := prodrow.p_qoh * prodrow.p_price;
    Dbms_Output.put_line('The total for '||prodrow.p_descript||' ('||prodrow.p_code||') is: '||total);
  END LOOP;   -- deallocate memory
  CLOSE prod_c;
  Dbms_Output.put_line('finished');
END;
/




/**************************** 20180416 ****************************************/

/**************************** PROCEDURES **************************************/



-- procedures have to be within a simple block
CREATE OR REPLACE PROCEDURE prod_totals AS
-- keeps from having to drop, etc.
-- beware of doing this in a shared environment
BEGIN
  DECLARE
    CURSOR prod_c IS  SELECT p_code,p_descript,p_qoh,p_price
                      FROM product p JOIN vendor v ON p.v_code = v.v_code
                      WHERE v_state IN ('TN','FL');
    prodrow prod_c%ROWTYPE;
    total NUMBER(10,2);
    lowcount NUMBER(2) := 0;
    highcount NUMBER(2) := 0;
  BEGIN
    OPEN prod_c;
    LOOP
      FETCH prod_c INTO prodrow;
      EXIT WHEN prod_c%NOTFOUND;
      total := prodrow.p_price * prodrow.p_qoh;
      IF total > 1000 THEN
        highcount := highcount+1;
      ELSE
        lowcount := lowcount+1;
      END IF;
      Dbms_Output.put_line(prodrow.p_code||': '||prodrow.p_descript||' = '||total);
    END LOOP;
    CLOSE prod_c;
    Dbms_Output.put_line('There are '||highcount||' products with a high total.');
    Dbms_Output.put_line('There are '||lowcount||' products with a low total.');
  END;
END;
/

EXECUTE prod_totals();
EXEC prod_totals;

SELECT * FROM user_procedures;


CREATE OR REPLACE PROCEDURE prod_discount AS
BEGIN
  UPDATE product
  SET p_discount = p_discount + .05
  WHERE p_qoh >= p_min * 2;
  Dbms_Output.put_line('Finished.');
END;
/

EXEC prod_discount;
SELECT * FROM product ORDER BY p_qoh DESC,p_min DESC;
ROLLBACK; -- remember that create is a DDL command
            -- rollback if you made a mistake in the procedure


-- let's add parameters, because why not?
-- formal parameter: <name> IN <unqualified datatype>
   -- never name a parameter the same as an attribute or variable
   -- IN, OUT, IN OUT   https://docs.oracle.com/cd/B28359_01/appdev.111/b28370/parameter_declaration.htm#CJADCJFE
CREATE OR REPLACE PROCEDURE prod_discount (temp_discount IN NUMBER) AS
BEGIN
  UPDATE product SET p_discount=p_discount+temp_discount
  WHERE p_qoh>=p_min*2;
  Dbms_Output.put_line('Updated by: '||temp_discount);
END;
/

EXEC prod_discount(0.1);
SELECT * FROM product ORDER BY p_qoh DESC,p_min DESC;
ROLLBACK;


-- more than one parameter, because awesome
CREATE OR REPLACE PROCEDURE prod_discount
          (temp_discount IN NUMBER,
           temp_multiplier IN NUMBER,
           temp_message IN VARCHAR) AS
BEGIN
  UPDATE product SET p_discount=p_discount+temp_discount
  WHERE p_qoh>=p_min*temp_multiplier;
  Dbms_Output.put_line(temp_message);
END;
/

EXEC prod_discount(0.5,2.5,'I am the greatest!');
SELECT * FROM product ORDER BY p_qoh DESC,p_min DESC;
ROLLBACK;





/**************************** 20180418 ****************************************/

/**************************** TRIGGERS ****************************************/



SELECT * FROM product;

-- this version is meh
CREATE OR REPLACE TRIGGER product_reorder
-- BEFORE or AFTER refers to the write to the database
AFTER INSERT OR UPDATE OF p_qoh ON product
-- associated DMLs ^
BEGIN
  -- trigger DMLs v
  UPDATE product SET p_reorder = 1 WHERE p_qoh <= p_min;
END;
/

SELECT * FROM user_triggers;

UPDATE product SET p_qoh = 4 WHERE p_code = '11QER/31';
ROLLBACK;

UPDATE product SET p_min = 10 WHERE p_code = '11QER/31';

SELECT * FROM product;



-- this version is better, less ambiguous
CREATE OR REPLACE TRIGGER product_reorder
AFTER INSERT OR UPDATE OF p_qoh,p_min ON product
BEGIN
  UPDATE product SET p_reorder = 1 WHERE p_qoh <= p_min;
END;
/

UPDATE product SET p_qoh = 15 WHERE p_code = '11QER/31';


-- this version is better still, but not really
CREATE OR REPLACE TRIGGER product_reorder
AFTER INSERT OR UPDATE OF p_qoh,p_min ON product
BEGIN
  UPDATE product SET p_reorder = 1 WHERE p_qoh <= p_min;
  UPDATE product SET p_reorder = 0 WHERE p_qoh > p_min;
END;
/


/******************************************************************************/
-- THIS VERSION IS BESTEST
CREATE OR REPLACE TRIGGER product_reorder
BEFORE INSERT OR UPDATE OF p_qoh,p_min ON product
FOR EACH ROW  -- without this, it's a statement level trigger... always this!!!!
BEGIN
  IF :new.p_qoh <= :new.p_min THEN               -- :old,:new are bind variables
    :new.p_reorder := 1;
  ELSE
    :new.p_reorder := 0;
  END IF;
END;
/
/******************************************************************************/
-- some rules from Dr. M
  -- there are only two ways to get data from DB to trigger:
    -- if row level trigger, and if data wanted is in the row being manipulated
        -- by the associated DML, then access it in a bind variable
    -- any other time, have to write a select query
  -- there are only two ways to get data from trigger to DB:
    -- if row level, and if BEFORE trigger, and data want to write goes in the
        -- row being manipulated by the associated DML, assign the value to :new
    -- any other time, write an ANSI DML (insert, update, delete)
/******************************************************************************/




