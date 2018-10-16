-- Ben Belden --

-- 1 --
/*
Write the CTAS commands to copy the tables from the above ERD from the LOSTTOURS schema. 
The table names must match those in the ERD exactly.
*/
CREATE TABLE tour AS SELECT * FROM losttours.tour;
CREATE TABLE qualify AS SELECT * FROM losttours.qualify;
CREATE TABLE guide AS SELECT * FROM losttours.guide;
CREATE TABLE outing AS SELECT * FROM losttours.outing;
CREATE TABLE register AS SELECT * FROM losttours.register;
CREATE TABLE client AS SELECT * FROM losttours.client;


-- 2 --
/*
Modify the TOUR table to add a primary key (PK) constraint. Make Tour_ID the primary key 
using either an attribute constraint or a table constraint (your choice).
*/
ALTER TABLE tour ADD CONSTRAINT tour_tour_id_pk PRIMARY KEY (tour_id);


-- 3 --
/*
Modify the OUTING table to add a single constraint that enforces a requirement that max 
capacity can never be greater than 100 and never less than 1.
*/
ALTER TABLE outing ADD CONSTRAINT outing_ck_max CHECK (out_MaxCapacity BETWEEN 1 AND 100);


-- 4 --
/*
Write the command to create the following table named LOCATION. Be certain that the create 
command enforces all specified constraints. Use an attribute constraint for the PK constraint. 
Use a table constraint to enforce the domain for loc_type. Use a table constraint to enforce 
the FK constraints.  All table constraints must be named using the naming convention covered 
in class for constraint names.
Column	    Data Type	                                    Constraints
Loc_Num	    10-digit integers	                            PK
Loc_Name	  Variable-length character up to 50 letters	  Not null
Loc_Type	  Variable-length character up to 20 letters	  Domain(“PUBLIC” or “PRIVATE”)
Tour_ID	    3-digit integers	                            FK from TOUR, Not null
*/
CREATE TABLE location
(
  loc_num   NUMBER(10) PRIMARY KEY                                ,
  loc_name  VARCHAR(50) NOT NULL                                  ,
  loc_type  VARCHAR(20) CHECK (loc_type IN ('PUBLIC','PRIVATE'))  ,
  tour_id   NUMBER(3)                                             ,
  CONSTRAINT table_tour_id_fk FOREIGN KEY (tour_id) REFERENCES tour
);


-- 5 --
/*
Write the commands to add the following rows to the table created above.
Loc_Num	  Loc_Name	              Loc_Type	  Tour_ID
1	        Grand Beach Outlook	    PUBLIC	     3
2	        Purdy Pavilion	        PRIVATE	     3
3	        Reach Point		                       3
*/
INSERT INTO location (loc_num,loc_name,loc_type,tour_id) VALUES (1,'Grand Beach Outlook','PUBLIC',3);
INSERT INTO location (loc_num,loc_name,loc_type,tour_id) VALUES (2,'Purdy Pavilion','PRIVATE',3);
INSERT INTO location (loc_num,loc_name,loc_type,tour_id) VALUES (3,'Reach Point',NULL,3);


-- 6 --
/*
Write the commands to:
  a. Assign guide Tyson Lane to lead outing 1163.
  b. Remove guide Patty Minter from the system
*/
UPDATE outing SET g_empnum =
(
  SELECT g_empnum FROM guide
  WHERE Upper(g_fname) = 'TYSON' AND Upper(g_lname) = 'LANE'
)
WHERE out_id = 1163;
DELETE FROM guide WHERE Upper(g_fname) = 'PATTY' AND Upper(g_lname) = 'MINTER';


-- 7 --
/*
Write a row-level PL/SQL trigger.  The purpose of the trigger is to prevent nulls 
in the registration fee. The trigger is applying logic to create a “default value” 
for registration fee based on the tour fee of the related row in the TOUR table. The 
trigger should meet the following requirements:
  a. The trigger should be named REG_FEE_TRG.
  b. The trigger should run only before an insert on the REGISTER table.
  c. The user is issuing a command to insert a new row in the REGISTER table because a 
      client is registering to go on an outing of one of the tours.  If the value being 
      inserted into the registration fee is NULL, then make the registration fee be the 
      same as the tour fee for the related tour. 
*/
CREATE OR REPLACE TRIGGER reg_fee_trg
BEFORE INSERT ON register
FOR EACH ROW
BEGIN
  DECLARE
    tourFee tour.tour_fee%TYPE := 0;
  BEGIN
    SELECT UNIQUE tour.tour_fee INTO tourFee
    FROM tour JOIN outing ON tour.tour_id = outing.tour_id
              JOIN register ON outing.out_id = register.out_id
    WHERE register.out_id = :new.out_id;
    IF :new.reg_fee IS NULL THEN
      :new.reg_fee := tourFee;
    END IF;
    EXCEPTION WHEN No_Data_Found THEN
      NULL;
  END;
END;
/


-- 8 --
/*
Write a row-level PL/SQL trigger. The purpose of the trigger is to provide a warning 
when a guide is assigned to lead an outing for which the guide is not qualified.  The 
trigger should meet the following requirements:
  a. The trigger should be named QUAL_GUIDE_TRG.
  b. The trigger should run only after inserting a new row in the OUTING table or updating 
      the G_EmpNum attribute in the OUTING table.
  c. The outing being inserted or updated is associated with a specific tour. Determine if 
      the guide is qualified for that tour.
  d. If the guide is not qualified for the tour related to this outing, output a warning 
      message that the guide is not qualified.
*/
CREATE OR REPLACE TRIGGER qual_guide_trg
AFTER INSERT OR UPDATE OF g_empnum ON outing
FOR EACH ROW
BEGIN
  DECLARE
    empNum guide.g_empnum%TYPE := '';
  BEGIN
    SELECT UNIQUE q.g_empnum INTO empNum
    FROM qualify q JOIN tour t ON q.tour_id = t.tour_id
    WHERE t.tour_id = :new.tour_id AND q.g_empnum = :new.g_empnum;
    IF :new.g_empnum = empNum THEN
      NULL;
    END IF;
    EXCEPTION WHEN No_Data_Found THEN
      Dbms_Output.put_line('Warning: Unqualified guide assigned to outing.');
  END;
END;
/


-- 9 --
/*
Write a PL/SQL stored procedure that meets the following requirements:
  a. The procedure should be named REGISTERCLIENT.
  b. The procedure will accept three parameters: a client number, an outing ID, and a 
      fee (in that order).
  c. Determine the maximum capacity for the outing identified by the outing ID provided 
      in the parameter.
  d. Determine the number of clients that have already registered for that outing.
  e. If the number of clients that have already registered is equal to or greater than the 
      maximum capacity for the outing, then output a message that the outing is already full.
  f. If the number of clients that have already registered is less than the maximum capacity 
      for the outing, then:
    i. Determine the outing date for the outing provided by the user.
    ii. If the outing date is earlier than the current date returned by the server, then output 
        a message that the client cannot be registered since the outing has already occurred and 
        include the outing date in the message.
    iii. If the outing date is not earlier than the current date returned by the server, then:
      1. If the current date returned by the server is more than 20 days prior to the outing date, 
          then subtract 25% from the fee provided by the user and output a message that an early 
          booking discount was applied.
      2. Insert a new row in the REGISTER table using the client number and outing ID provided by 
          the parameters.  Use the fee provided by the parameter (or the discounted fee calculated 
          in the previous step, if it applied) as the register fee, and use the current date returned 
          by the server as the registration date.
      3. Output a message that the user was registered.  Include the client first and last name, tour 
          name, and outing date in the message.
*/
CREATE OR REPLACE PROCEDURE registerclient (clNum client.client_num%TYPE,
                                            outID outing.out_id%TYPE,
                                            fee register.reg_fee%TYPE) AS
BEGIN
  DECLARE
    maxCap outing.out_maxcapacity%TYPE;
    cap outing.out_maxcapacity%TYPE;
    outDate outing.out_date%TYPE;
    curDate outing.out_date%TYPE := SYSDATE - 10;
    regFee register.reg_fee%TYPE := fee;
    fname client.client_fname%TYPE;
    lname client.client_lname%TYPE;
    tname tour.tour_name%TYPE;
  BEGIN
    SELECT out_maxcapacity INTO maxCap FROM outing WHERE out_id = outID;
    SELECT Count(*) INTO cap FROM register WHERE out_id = outID;
    SELECT out_date INTO outDate FROM outing WHERE out_id = outID;
    SELECT client_fname,client_lname INTO fname,lname FROM client
      WHERE client_num = clNum;
    SELECT tour_name INTO tname FROM tour
      JOIN outing ON tour.tour_id = outing.tour_id WHERE out_id = outID;

    IF cap >= maxCap THEN
      Dbms_Output.put_line('Client cannot be registered. The outing is full.');
    ELSE
      IF outDate < curDate THEN
        Dbms_Output.put_line('Client cannot be registered. '||
                             'The outing occurred on '||outDate||'.');
      ELSE
        IF (curDate + 20) < outDate THEN
          regFee := regFee - (0.25 * regFee);
          Dbms_Output.put_line('Early booking discount eligible. '||
                               'Discount applied.');
        END IF;
        INSERT INTO register (out_id,client_num,reg_date,reg_fee)
            VALUES (outID,clNum,curDate,regFee);
        Dbms_Output.put_line(fname||' '||lname||' successfully added to the '
                                  ||tname||' tour outing on '||curDate||'.');
      END IF;
    END IF;
  END;
END;
/

