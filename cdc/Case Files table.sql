
CREATE TABLE amlcasefiles (
    fileid VARCHAR ( 32 ) PRIMARY KEY,
	caseid BIGINT,
    s3url VARCHAR ( 50 ),
    body TEXT,
    filetype VARCHAR ( 10 ),
    adddate TIMESTAMP
);