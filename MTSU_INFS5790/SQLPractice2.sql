/*
Create tables for the following ERD:


Given: 
Play_ID is an integer number up to 5 digits.
Team_ID is an integer number up to 3 digits.
Play_FName is variable length text up to 15 characters.
Play_LName is variable length text up to 15 characters.
Play_DOB is a date.

Team_ID is an integer up to 3 digits.
Team_Name is variable length text up to 12 characters.
Team_Mascot is variable length text up to 12 characters.

Constraints:
Primary key and foreign key constraints should be enforced.
All attributes in PLAYER should be required.
Play_Payment should have a default vale of 0.
Team_Name should be required and should be unique.
*/

-- DROP TABLE team;
CREATE TABLE team
(
  team_id       NUMBER(3) PRIMARY KEY       ,
  team_name     VARCHAR(20) UNIQUE NOT NULL ,
  team_mascot   VARCHAR(12)
);
-- DROP TABLE player;
CREATE TABLE player
(
  play_id       NUMBER(5) PRIMARY KEY             ,
  team_id       NUMBER(3) NOT NULL                ,
  play_fname    VARCHAR(15)  NOT NULL             ,
  play_lname    VARCHAR(15)  NOT NULL             ,
  play_dob      DATE  NOT NULL                    ,
  play_payment  NUMBER(5,2)  DEFAULT 0 NOT NULL   ,
  CONSTRAINT player_team_id_fk FOREIGN KEY (team_id) REFERENCES team
);
-- SELECT * FROM team;


-- Write SQL statements to complete the following actions:

-- 1 --
/*
Insert the following data into the TEAM table:
Team_ID     Team_Name         Team_Mascot
99          Radiers           Pirate
100         Mini Munchers     Pac-man
101         Fierce Flowers    Angry Daisy
98          Raptors           
103         Crabs             Crab
*/
INSERT INTO team (team_id,team_name,team_mascot) VALUES(99,'Raiders','Pirate');
INSERT INTO team VALUES(100,'Mini Munchers','Pac-man');
INSERT INTO team VALUES(101,'Fierce Flowers','Angry Daisy');
INSERT INTO team VALUES(98,'Raptors',NULL);
INSERT INTO team VALUES(103,'Crabs','Crab');
-- SELECT * FROM player;


-- 2 --
/*
Insert the following data into the PLAYER table:
Play_ID   Team_ID   Play_FName    Play_LName    Play_DOB      Play_Payment
10001     98        Sam           Waters        05/23/2007    $30.00
10002     100       Percy         Waters        09/03/2011    $30.00
10003     98        Jamie         Rushing       02/20/2009    0
10004     103       Jason         Dearing       11/14/2011    $10.00
10005     103       Nicholas      Penn          05/20/2009    0
10006     100       Telly         Makems        04/12/2012    $30.00
*/  
INSERT INTO player VALUES (10001,98,'Sam','Waters','23-MAY-2007',30);
INSERT INTO player VALUES (10002,100,'Percy','Waters','03-SEP-2011',30);
INSERT INTO player VALUES (10003,98,'Jamie','Rushing','20-FEB-2009',0);
INSERT INTO player VALUES (10004,103,'Jason','Dearing','14-NOV-2011',10);
INSERT INTO player VALUES (10005,103,'Nicholas','Penn','20-MAY-2009',0);
INSERT INTO player VALUES (10006,100,'Telly','Makems','12-APR-2012',30);


-- 3 --
-- Update the payment for player 10003 to $20.00.
UPDATE player SET play_payment = 20 WHERE play_id = 10003;


-- 4 --
-- Delete the row for team 101.
DELETE FROM team WHERE team_id = 101;


-- 5 --
-- Update the mascot for team 98 to "Dinosaur".
UPDATE team SET team_mascot = 'Dinosaur' WHERE team_id = 98;


-- 6 --
-- Add a constraint to make team_mascot required to have a value.
ALTER TABLE team MODIFY team_mascot NOT NULL;


-- 7 --
-- Add a constraint to require play_payment to be greater than or equal to zero.
ALTER TABLE player ADD CONSTRAINT player_play_pmt_not_neg CHECK (play_payment >= 0);


-- 8 --
-- Update the date of birth for player 10001 to May 23, 2010.
UPDATE player SET play_dob = '23-MAY-2010' WHERE play_id = 10001;


-- 9 --
-- Commit these changes to make them permanent.
COMMIT;


-- 10 --
-- Delete all players associated with team 103.
DELETE FROM player WHERE team_id = 103;


-- 11 --
-- Delete team 103.
DELETE FROM team WHERE team_id = 103;


-- 12 --
-- Rollback these changes.
ROLLBACK;


-- 13 --
-- Add $10 to play_payment for every player.
UPDATE player SET play_payment = play_payment + 10;


-- 14 --
-- Commit these changes to make them permanent.
COMMIT;


-- SELECT * FROM team;
-- SELECT * FROM player;
