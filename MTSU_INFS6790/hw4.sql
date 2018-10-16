-- 2 --
CREATE DIRECTORY dpexport AS 'C:\app\OracleOwner\Backup';

-- 3 --
CREATE TABLE bpb2v_test AS SELECT * FROM dba_procedures;
SELECT * FROM user_tables WHERE table_name LIKE 'B%';
SELECT * FROM bpb2v.bpb2v_test;
SELECT owner,table_name FROM all_tables WHERE table_name LIKE 'B%';

-- 4 --
-- expdp user/pass@host tables=bpb2v.bpb2v_test directory=dpexport dumpfile=bpb2v_test_exp.dmp

-- 5 --
DROP TABLE bpb2v_test;

-- 6 --
-- impdp user/pass@host tables=bpb2v.bpb2v_test directory=dpexport dumpfile=bpb2v_test_exp.dm

-- 7 --
SELECT * FROM bpb2v_test;

-- 8 --
SELECT name,
  floor(space_limit / 1024 / 1024) "Size MB",
  ceil(space_used / 1024 / 1024) "Used MB"
FROM v$recovery_file_dest
ORDER BY name;

-- 9 --
-- rman target user/pass@host

-- 10 --
-- RMAN> show all;

-- 11 --
-- config to:
  -- auto backup control file
  -- compress backup into compressed backup sets
  -- change retention policy to include an 8-day window

-- 12 --
-- RMAN> show all;

-- 13 --
-- determine which backup files and archive logs are missing or obsolete, delete expires
--

-- 14 --
SELECT name,
  floor(space_limit / 1024 / 1024) "Size MB",
  ceil(space_used / 1024 / 1024) "Used MB"
FROM v$recovery_file_dest
ORDER BY name;

-- 15 --
-- create full backup of db as image copy, include archive logs
-- backup as copy database plus archivelog;

-- 16 --
-- validate db integrity
-- restore validate database;

-- 17 --
-- list backup of database;

-- 18 --
-- locate image copies on HDD

-- 19 --
-- create a level 0 incremental backup to a backup set
-- backup incremental level 0 database;

-- 20 --
-- create a table similar to #3
CREATE TABLE bpb2v_test2 AS SELECT * FROM dba_procedures;
SELECT * FROM user_tables WHERE table_name LIKE 'B%';

-- 21 --
-- create level 1 differential incremental backup
-- backup incremental level 1 database;

-- 22 --
-- list summary of backup files in rman
-- list backup of database;

-- 23 --
-- locate backup set files on HDD

-- 24 --
-- validate integrity of restoration
-- restore validate database;

-- 25 --
-- create recovery file of 12GB in: C:\app\OracleOwner\fast_recovery_area\bb6790

-- 26 --
-- configure DB for flashback
  -- set "recovery_file" parameters
  -- set retention target to 60
  -- restart DB
  -- verify flashback is enabled

-- 27 --
-- create a flashback restore point as: bb6790_09242018 (today's date)





SELECT Value FROM V$PARAMETER WHERE name='service_names';
ALTER USER bpb2v IDENTIFIED BY password account unlock;

