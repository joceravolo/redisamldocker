
CREATE TABLE amlcases (
	caseid BIGINT PRIMARY KEY,
	status VARCHAR ( 20 ) NOT NULL,
	investigator INT,
    amount REAL,
    files TEXT,
    reportdate TIMESTAMP,
    lastupdate TIMESTAMP,
    report TEXT,
    accountid INT,
    ssn INT,
    phone VARCHAR ( 20 ),
    ip VARCHAR ( 11 ),
    casebody TEXT,
    priority VARCHAR ( 10 ),
    relatedtags TEXT
);