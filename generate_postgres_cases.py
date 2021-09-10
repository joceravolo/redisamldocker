from redis import Redis
from redis.exceptions import ResponseError,ConnectionError
from os import environ,urandom,fork
from uuid import uuid1,uuid4
import random
from time import sleep
from logging import debug, info
from faker import Faker
import json
import itertools
import psycopg2
from datetime import datetime

def insert_postgres_case(fake, id):

    statuses = ["new","investigating","resolved","on-hold","archived"]
    priorities = ["low","med","high"]
    date_range = [1389576338,1601861138] # Jan 13 2014 to Oct 5 2020

    caseid = maxid + id
    status = statuses[random.randrange(0,len(statuses))]
    investigator = random.randrange(501001,501501)
    value = int(abs(random.gauss(10000,300000)))

    files = str(uuid1()).replace("-","")
    for _ in itertools.repeat(None,random.randrange(1,8)):
        files = files + "," + str(uuid4()).replace("-","")
    tempdate = random.randrange(date_range[0],date_range[1])
    reportdate = datetime.fromtimestamp(tempdate)
    # + 20 days or 100 days
    lastupdate = datetime.fromtimestamp(tempdate + random.randrange(1728000,8640000)) 
    body = fake.text()
    acctno = fake.ean8(prefixes=("41","82","21","97"))
    ssn = str(fake.ssn()).replace("-","")
    phone = fake.phone_number()
    ip = fake.ipv4()
    FullName = fake.name() 
    Street = fake.street_address() 
    Country = "US"
    State = "NB" 
    PostCode = fake.postcode()
    priority = priorities[random.randrange(0,len(priorities))]
    tags = acctno
    for _ in itertools.repeat(None,random.randrange(4,19)):
        tags = tags + "," + fake.ean8(prefixes=("41","82","21","97"))
    
    #print(f"Case Id {caseid} Status {status} Investigator {investigator} Phone {phone}")
    # insert into postgres
    mcursor.execute("insert into amlcases (caseid, fullname, street, state, postcode,status,investigator,amount,files,reportdate,lastupdate,casebody,accountid,ssn,phone,ip,priority,relatedtags) values (%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s)", (caseid,FullName,Street,State,PostCode,status,investigator,value,files,reportdate,lastupdate,body,acctno,ssn,phone,ip,priority,tags))
    #mcursor.execute("insert into amlcases (caseid, fullname, street, state, postcode,status,investigator,amount) values (%s,%s,%s,%s)", (caseid,status,investigator,value))
    
                        
    return 


# Connect to PostgreSQL container
print("Connecting to Postgres database...")
conn = psycopg2.connect(
    host="localhost",
    database="postgres",
    user="postgres",
    password="mysecretpassword")
mcursor = conn.cursor()
mcursor.execute('SELECT version()')
#db_version = mcursor.fetchone()
print('PostgreSQL database version: ', mcursor.fetchone()[0])

#mcursor.execute("select * from amlcases")
#mrows = mcursor.fetchall()

#for r in mrows:
#    print(f"Case Id {r[0]} Status {r[1]} Investigator {r[2]}")
    
print("Inserting 10000 records into amlcases table.")
count = 10000
fake = Faker()
counter = 0
maxid = mcursor.execute("select max(caseid) from amlcases")
maxid = mcursor.fetchone()[0]
if maxid is None: 
	maxid = 100000
while counter <= int(count):
    if (counter % 1000 == 0):
    	print("Count:", counter)
    insert_postgres_case(fake,counter+1)
    counter = counter + 1

conn.commit()
mcursor.close()
conn.close()
print("Connection to postgres closed.")
    

