
-- 2 --
SELECT username, action_name, returncode,Count(returncode) AS "Successful Logins"
FROM dba_audit_trail
GROUP BY username, action_name, returncode
HAVING (username='NORMALGUY' OR username='SUPERGAL') AND returncode=0 AND action_name='LOGON';

-- 3 --
SELECT username, action_name, returncode,Count(returncode) AS "Unsuccessful Logins"
FROM dba_audit_trail
GROUP BY username, action_name, returncode
HAVING (username='NORMALGUY' OR username='SUPERGAL') AND returncode!=0 AND action_name='LOGON';

-- 4 --
SELECT username,TIMESTAMP,returncode,sql_text FROM dba_audit_trail
WHERE username='NORMALGUY' AND action_name='SELECT';

-- 5 --
SELECT username,TIMESTAMP,returncode,sql_text FROM dba_audit_trail
WHERE username='SUPERGAL' AND action_name='SELECT';

-- 6 --
SELECT username,TIMESTAMP,action_name,obj_name FROM dba_audit_trail
WHERE action_name='CREATE TABLE';
SELECT * FROM normalguy.employee;
SELECT * FROM supergal.zipcodes;










