-- Create table for the ML Case Files using the query editor on Azure Data Studio or another: 

CREATE TABLE amlcasefiles ( 
fileid VARCHAR ( 32 ) PRIMARY KEY, 
caseid BIGINT, 
s3url VARCHAR ( 50 ), 
body TEXT, 
filetype VARCHAR ( 10 ), 
adddate TIMESTAMP 
); 

 -- Create table for the Cases: 

CREATE TABLE amlcases ( 
caseid BIGINT PRIMARY KEY, 
fullname VARCHAR ( 50 ) NOT NULL,
Street VARCHAR ( 50 ) NOT NULL,
State CHAR ( 2 ) NOT NULL,
PostCode VARCHAR ( 10 ) NOT NULL,
status VARCHAR ( 20 ) NOT NULL, 
investigator INT, 
amount REAL, 
files TEXT, 
reportdate TIMESTAMP, 
lastupdate TIMESTAMP, 
report TEXT, 
accountid INT, 
ssn INT, 
phone VARCHAR ( 25 ), 
ip VARCHAR ( 15 ), 
casebody TEXT, 
priority VARCHAR ( 10 ), 
relatedtags TEXT 
); 

 
-- Enable Replica for the tables, this is necessary for the CDC: 

ALTER TABLE amlcases REPLICA IDENTITY FULL; 

ALTER TABLE amlcasefiles REPLICA IDENTITY FULL; 
