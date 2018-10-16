/**************************** Practice Anonymous Blocks ******************************/

-- 1 --
/*
Create an anonymous block program that meets the following requirements: 
  a. Create two variables (FName & LName), both variable length text up to 20 characters.
  b. Assign the value "Thomas" to the FName variable.
  c. Assign the value "Harding" to the LName variable.
  d. Output a message saying hello using the variables.
*/
DECLARE
  fname   VARCHAR(20) := 'Thomas';
  lname   VARCHAR(20) := 'Harding';
BEGIN
  Dbms_Output.put_line('Hello, '||fname||' '||lname||'.');
END;
/


-- 2 --
/*
Create an anonymous block program that meets the following requirements: 
  a. Create five variables. Two to hold team names, two to hold game scores, and one to hold 
      the calculated difference between the scores.
  b. Assign the name "Richmond Rockets" to one team name variable.
  c. Assign the name "Kentucky Kangaroos" to the other team name variable.
  d. Assign the values 75 and 60 to the team score variables.
  e. Use an IF statement to determine which team had the higher score.
  f. Calculate the difference between the scores.
  g. Output a message saying which team won and by how much.
*/
DECLARE
  team1   VARCHAR(20) := 'Richmond Rockets';
  team2   VARCHAR(20) := 'Kentucky Kangaroos';
  score1  NUMBER      := 75;
  score2  NUMBER      := 60;
  scoreDiff NUMBER    := 0;
BEGIN
  IF score1 > score2 THEN
    scoreDiff := score1 - score2;
    Dbms_Output.put_line(team1||' won by '||scoreDiff||' points.');
  ELSE
    scoreDiff := score2 - score1;
    Dbms_Output.put_line(team2||' won by '||scoreDiff||' points.');
  END IF;
END;
/


-- 3 --
/*
Create an anonymous block program that meets the following requirements: 
  a. Create variables to hold a customer code, first name, and last name from the CUSTOMER table.
  b. Assign the value "10010" to the variable for the customer code.
  c. Retrieve the customer first and last name rom the CUSTOMER table for the customer 
      that has the customer code in the customer variable.
  d. Output a message stating the customer's name.
*/
DECLARE
  code customer.cus_code%TYPE;
  fname customer.cus_fname%TYPE;
  lname customer.cus_lname%TYPE;
BEGIN
  code := 10010;
  SELECT cus_fname,cus_lname INTO fname,lname FROM customer WHERE cus_code = code;
  Dbms_Output.put_line('The customer is '||fname||' '||lname||'.');
END;
/


-- 4 --
/*
Create an anonymous block program that meets the following requirements: 
  a. Create variables to hold a customer code, first name, and last name from the CUSTOMER table.
  b. Create a variable to hold a whole number up to 3 digits.
  c. Assign the value "10010" to the customer code variable.
  d. Use a Count function to determine how many rows in the CUSTOMER table have a customer
      code that matches the value in the customer code variable.
  e. If the count returns a value of only 1, then get the customer's first and last name and 
      place them in the corresponding variables. Then output the customer's name in a message.
  f. If the count returns a value of 0 rows, then output a message that the customer does not exist.
*/
DECLARE
  code customer.cus_code%TYPE := 10010;
  fname customer.cus_fname%TYPE;
  lname customer.cus_lname%TYPE;
  num NUMBER(3);
BEGIN
  SELECT Count(cus_code) INTO num FROM customer WHERE cus_code = code;
  IF num = 0 THEN
    Dbms_Output.put_line('No customer exists with the customer code given.');
  ELSE
    SELECT cus_fname,cus_lname INTO fname,lname FROM customer WHERE cus_code = code;
    Dbms_Output.put_line('The customer is '||fname||' '||lname||'.');
  END IF;
END;
/




/***************************** Practice Procedures ****************************/


-- 1 --
/*
Create a PL/SQL anonymous block that will provide information on the most expensive products in 
the system. The program should perform the following tasks:
  a. Retrieve the largest price (p_price) in the product table, and assign it to a variable.
  b. Using the variable that contains the largest price, retrieve a count of the products that have
      this price and assign that count to a variable.
  c. Use an IF statement to determine which of the following actions to take:
    c1. If the count determined that only one product has the maximum price, then retrieve the p_code and 
        p_descript of that product and assign them to variables. Then output the p_code and p_descript
        of that product to the screen with an explanatory sentence.
    c2. If the count determined that more than one product has the maximum price, then output the 
        number of products with that price.
*/
DECLARE
  largest product.p_price%TYPE := 0;
  cnt NUMBER := 0;
  code product.p_code%TYPE;
  descript product.p_descript%TYPE;
BEGIN
  SELECT Max(p_price) INTO largest FROM product;
  SELECT Count(*) INTO cnt FROM product WHERE p_price = largest;
  IF cnt = 1 THEN
    SELECT p_code,p_descript INTO code,descript FROM product WHERE p_price = largest;
    Dbms_Output.put_line('The product with the highest price is '||code||', which is a '||descript||'.');
  ELSE
    Dbms_Output.put_line('There are '||cnt||' products with a price of '||largest||'.');
  END IF;
END;
/


-- 2 --
/*
Convert the program in #1 above into a stored procedure named TOP_PRODS.
*/
CREATE OR REPLACE PROCEDURE top_prods AS
BEGIN
  DECLARE
    largest product.p_price%TYPE := 0;
    cnt NUMBER := 0;
    code product.p_code%TYPE;
    descript product.p_descript%TYPE;
  BEGIN
    SELECT Max(p_price) INTO largest FROM product;
    SELECT Count(*) INTO cnt FROM product WHERE p_price = largest;
    IF cnt = 1 THEN
      SELECT p_code,p_descript INTO code,descript FROM product WHERE p_price = largest;
      Dbms_Output.put_line('The product with the highest price is '||code||', which is a '||descript||'.');
    ELSE
      Dbms_Output.put_line('There are '||cnt||' products with a price of '||largest||'.');
    END IF;
  END;
END;
/
-- for testing -- 
EXEC top_prods;


-- 3 --
/*
Create a PL/SQL stored procedure called CUST_PAY that will record customer payments.
The procedure should meet the following requirements:
  a. The procedure should accept the customer code and payment amount as parameters.
  b. check to see if the customer code provided can be found in the database.
  c. If the customer code is found then reduce the customer's balance by the payment amount.
  d. If the customer code is found then reduce the customer's balance by the payment amount.
  e. If the customer now has a negative balance, then display a message indicating that the
      customer is owed a refund and the amount that the customer is owed.
  f. If the customer still has a positive balance, then display a message indicating the new balance.
*/
CREATE OR REPLACE PROCEDURE cust_pay (code IN customer.cus_code%TYPE,pmt IN customer.cus_balance%TYPE) AS
BEGIN
  DECLARE
    CURSOR cus_curs IS SELECT * FROM customer WHERE cus_code = code;
    cus_row cus_curs%ROWTYPE;
    newBal customer.cus_balance%TYPE;
  BEGIN
    OPEN cus_curs;
    FETCH cus_curs INTO cus_row;
    IF cus_curs%FOUND THEN
      newBal := cus_row.cus_balance - pmt;
      UPDATE customer SET cus_balance = newBal WHERE cus_code = code;
      IF newBal < 0 THEN
        Dbms_Output.put_line('Refund due: '||(newBal * -1));
      ELSE
        Dbms_Output.put_line('New balance: '||newBal);
      END IF;
    ELSE
      Dbms_Output.put_line('Customer '||code||' not found.');
    END IF;
    CLOSE cus_curs;
  END;
END;
/
-- for testing -- 
SELECT * FROM customer;
EXEC cust_pay(10012,100);
ROLLBACK;
UPDATE customer SET cus_balance = 345.86 WHERE cus_code = 10012;


-- 4 --
/*
Create a PL/SQL stored procedure called PAYMENTS that will provide information on the amount of 
payments a customer has made. The procedure should meet the following requirements:
  a. The procedure should accept the customer code as a parameter.
  b. Check to see if the customer code provided can be found in the database.
  c. If the customer code does not match an existing customer code, then display a message
      saying that the customer cannot be found.
  d. If the customer code is found and the customer has at least one invoice, then determind the
      total value of all invoices associated with that customer.
    d1. Subtract that total from the customer's balance to determine the total amount of payments
        the customer must have made.
    d2. Display a message indicating the customer's name and the amount that they have paid.
*/
CREATE OR REPLACE PROCEDURE payments (code IN customer.cus_code%TYPE) AS
BEGIN
  DECLARE
    CURSOR cus_curs IS SELECT * FROM customer WHERE cus_code = code;
    cus_row cus_curs%ROWTYPE;
  BEGIN
    OPEN cus_curs;
    FETCH cus_curs INTO cus_row;
    IF cus_curs%FOUND THEN
      --Dbms_Output.put_line('Customer '||code||' found.');
      get_pmts(code);
    ELSE
      Dbms_Output.put_line('Customer '||code||' not found.');
    END IF;
    CLOSE cus_curs;
  END;
END;
/
CREATE OR REPLACE PROCEDURE get_pmts (code IN customer.cus_code%TYPE) AS
BEGIN
  DECLARE
    CURSOR inv_curs IS
                SELECT *
                FROM invoice  JOIN line ON invoice.inv_number = line.inv_number
                              JOIN customer ON customer.cus_code = invoice.cus_code
                WHERE customer.cus_code = code;
    inv_row inv_curs%ROWTYPE;
    total line.line_price%TYPE := 0;
    fname customer.cus_fname%TYPE;
    lname customer.cus_lname%TYPE;
    name VARCHAR(50);
    bal customer.cus_balance%TYPE;
    pmts customer.cus_balance%TYPE;
  BEGIN
    OPEN inv_curs;
    FETCH inv_curs INTO inv_row;
    IF inv_curs%FOUND THEN
      fname := inv_row.cus_fname;
      lname := inv_row.cus_lname;
      bal := inv_row.cus_balance;
      name := fname||' '||lname;
      --Dbms_Output.put_line('bal: '||bal);
      --Dbms_Output.put_line('Invoice found.');
      LOOP
        EXIT WHEN inv_curs%NOTFOUND;
        total := total + (inv_row.line_units * inv_row.line_price);
        --Dbms_Output.put_line('total: '||total);
        FETCH inv_curs INTO inv_row;
      END LOOP;
      pmts := bal - total;
      Dbms_Output.put_line(name||' has paid '||pmts||'.');
    ELSE
      Dbms_Output.put_line('Invoice not found.');
    END IF;
    CLOSE inv_curs;
  END;
END;
/
-- for testing -- 
SELECT * FROM customer;
EXEC payments(10012);
ROLLBACK;
SELECT * FROM invoice 
  JOIN line ON invoice.inv_number = line.inv_number 
  JOIN customer ON customer.cus_code = invoice.cus_code 
  WHERE customer.cus_code = 10012;


-- 5 --
/*
Create a stored procedure named PURCH_HISTORY that will provide a list of every product
purchased by a given customer. The procedure should meet the following requirements.
  a. The procedure should accept a customer code as a parameter.
  b. Check to see if the customer is associated with any invoices. If not, then output a message
      saying that no purchases were found for that customer.
  c. If the customer does have purchases, find the product code, product description, and invoice 
      date for every purchase made by that customer, and display them to the user.
*/
CREATE OR REPLACE PROCEDURE purch_history (code IN customer.cus_code%TYPE) AS
BEGIN
  DECLARE
    CURSOR inv_curs IS
      SELECT p.p_code,p.p_descript,i.inv_date
      FROM invoice i JOIN line l ON i.inv_number = l.inv_number
                     JOIN product p ON p.p_code = l.p_code
      WHERE i.cus_code = code;
    inv_row inv_curs%ROWTYPE;
  BEGIN
    OPEN inv_curs;
    FETCH inv_curs INTO inv_row;
    IF inv_curs%NOTFOUND THEN
      Dbms_Output.put_line('No invoices found.');
    ELSE
      LOOP
        EXIT WHEN inv_curs%NOTFOUND;
        Dbms_Output.put_line(To_Char(inv_row.inv_date,'Mon dd, yyyy')||' - '||inv_row.p_code||': '||inv_row.p_descript);
        FETCH inv_curs INTO inv_row;
      END LOOP;
    END IF;
    CLOSE inv_curs;
  END;
END;
/
-- for testing -- 
EXEC purch_history(10011);
SELECT p.p_code,p.p_descript,i.inv_date
FROM invoice i JOIN line l ON i.inv_number = l.inv_number
               JOIN product p ON p.p_code = l.p_code
WHERE i.cus_code = 10011;


-- 6 --
/*
Create a sequence named CHECK_NUM_SEQ that starts with 10000, increments by 1, and doesn't cache any values.
*/
CREATE SEQUENCE check_num_seq
START WITH 10000
INCREMENT BY 1
NOCACHE;
/*
Create a PL/SQL stored procedure called CHECK_OUT_BOOK that will record a patron checking out a book.
The procedure should meet the following requirements:
  a. The procedure should accept a book number and a patron id as parameters.
  b. Check to see if the book number exists in the database. If it doesn't, then output a message that
      the book number was not found.
  c. Check to see if the patron id exists in the database. If it doesn't, then outpus a message that
      the patron was not found.
  d. If the book and patron both exist in the database, check to see if the book is already checked out.
      If the book is already checked out, then output a message that it is already checkd out and display
      the name of the patron that it is checked out to.
  e. If the book and patron both exist in the database and the book is not already checked out, then insert 
      a new row in the CHECKOUT table to record this new checkout. Use the sequence created above to generate
      a value for check_num. Use the book number and the patron id provided in the parameters. Use the current
      date from the server for the check_out_date. The due date should be 14 days from the check_out_date, 
      and the check_in_date should be null. Then output a message saying the checkout has been recorded.
*/
CREATE OR REPLACE PROCEDURE check_out_book (bookNum book.book_num%TYPE, patID patron.pat_id%TYPE) AS
BEGIN
  DECLARE
    CURSOR bk_curs IS SELECT * FROM book b JOIN patron p ON b.pat_id = p.pat_id WHERE book_num = bookNum;
    CURSOR pat_curs IS SELECT * FROM patron WHERE pat_id = patID;
    CURSOR ckout_curs IS SELECT book_num FROM checkout WHERE check_in_date IS NULL;
    bk_row bk_curs%ROWTYPE;
    pat_row pat_curs%ROWTYPE;
    ckout_row ckout_curs%ROWTYPE;
    ckBook book.book_num%TYPE;
    ckPat patron.pat_id%TYPE;
  BEGIN
    SELECT book_num INTO ckBook FROM book WHERE book_num = bookNum;
    SELECT pat_id INTO ckPat FROM patron WHERE pat_id = patID;
    OPEN bk_curs;
    OPEN pat_curs;
    OPEN ckout_curs;
    FETCH bk_curs INTO bk_row;
    FETCH pat_curs INTO pat_row;
    FETCH ckout_curs INTO ckout_row;
    IF ckBook IS NULL THEN
      Dbms_Output.put_line('Book number '||bookNum||' not found.');
    END IF;
    IF ckPat IS NULL THEN
      Dbms_Output.put_line('Patron id '||patID||' not found.');
    END IF;
    IF ckBook IS NOT NULL AND ckPat IS NOT NULL THEN
      LOOP
        IF ckout_curs%NOTFOUND THEN
          Dbms_Output.put_line('book not checked out, checkout book');
          Dbms_Output.put_line('Book '||bookNum||' has been checkout out to patron '||patID||'.');
          EXIT;
        END IF;
        IF bookNum = ckout_row.book_num THEN
          Dbms_Output.put_line('Book '||bookNum||' already checked out to '||bk_row.pat_fname||' '||bk_row.pat_lname||'.');
          EXIT;
        END IF;
        FETCH ckout_curs INTO ckout_row;
      END LOOP;
    END IF;
    CLOSE bk_curs;
    CLOSE pat_curs;
    CLOSE ckout_curs;
  END;
END;
/
-- for testing -- 
SELECT * FROM patron,book;
EXEC check_out_book(5236,1160);
SELECT book_num FROM checkout WHERE CHECK_in_date IS null;
SELECT * FROM book JOIN patron ON book.pat_id = patron.pat_id WHERE book_num = 5236;
SELECT book_num FROM book WHERE book_num = 5236;





/***************************** Practice Triggers ******************************/


-- 1 --
/*
Create a row-level trigger called TRG_DISCOUNT that meets the following requirements:
  a. The trigger should run before an update of the p_discount atribute in the PRODUCT table.
  b. If the discount is being increased, then that will mean that we are carrying a little
      too many of the product. Your trigger should reduce p_min by 3 unless that would drop
      the p_min to zero or less, in which case p_min should be set to 3. 
  c. If the discount is being increased and if the p_min is greater than or equal to 10, then
      we are carrying far too many of the product. Your trigger should reduce p_min by 8.
  d. If the discount is being decreased, then we can carry more of the product. Your trigger
      should raise p_min by 10.
  e. Output a message to the user saying how much p_min was changed.
*/
CREATE OR REPLACE TRIGGER trg_discount
BEFORE INSERT OR UPDATE OF p_discount ON product
FOR EACH ROW
BEGIN
  IF :new.p_discount > :old.p_discount AND :new.p_min < 10 THEN
    :new.p_min := :new.p_min - 3;
    IF :new.p_min <= 0 THEN
      :new.p_min := 1;
    END IF;
  ELSIF :new.p_discount > :old.p_discount AND :new.p_min >= 10 THEN
    :new.p_min := :new.p_min - 8;
  ELSIF :new.p_discount < :old.p_discount THEN
    :new.p_min := :new.p_min + 10;
  END IF;
  Dbms_Output.put_line('Old p_min: '||:old.p_min);
  Dbms_Output.put_line('New p_min: '||:new.p_min);
END;
/
SELECT * FROM product WHERE p_code = 'WR3/TT3';
UPDATE product SET p_min = 25 WHERE p_code = 'WR3/TT3';
UPDATE product SET p_discount = p_discount * 1.75 WHERE p_code = 'WR3/TT3';
ROLLBACK;


-- 2 --
/*
The library is imposing guidelines on the number of books that a patron should have at
one time. The limit for faculty is 3 books at a time, and for students the limit is 5 
books at a time. If a patron checks out more books than the limit, the system should give
a warning. Create a row-level trigger called CHECK_OUT that meets the following requirements:
  a. The trigger should run after insert or update of the book_num or pat_id attributes of 
      the CHECKOUT table.
  b. Count how many books the patron already has checked out currently.
  c. If the current number of checkouts for that patron is greater than the limit for their
      patron type, then display a message to the screen indicating the patron's name and how
      many books they already have checked out.
  d. Update the pat_id of the BOOK table to indicate which patron is checking the book out.
*/


-- 3 --
/*
There is always great demand for books on Database so books with that subject are due back at
the library sooner than books on other subjects. Create a row-level trigger called CHECOUT_DUE 
that mees the following requirements:
  a. The trigger should run before an insert on the CHECKOUT table.
  b. If the book being checked out is on the subject of Database, then make the due date for 
      that checkout be 7 days after the checkout date. If the subject is not Database, then the 
      due date should be 14 days after the checkout date.
*/


-- 4 --
/*
Create a row-level trigger called CHECKOUT_RETURN that meets the following requirements:
  a. The trigger should run before an update of the check_in_date attribute of the CHECKOUT table.
  b. If the check_in_date being entered in the row is not null, then:
    b1. if the check_in_date being entered is earlier than the check_out_date, then:
      b1a. output a message saying that the book cannot be returned before it is checkout out.
      b1b. set the value of check_in_date to NULL.
    b2. if the check_in_date being entered is not earlier than the check_out_date, then:
      b2a. set the pat_id attribute in the BOOK table to NULL for the book that is being returned.
*/


