from redis import Redis
from redis.exceptions import ResponseError,ConnectionError
from os import environ,urandom,fork



#connect to redis and create search schema
print("Connecting to amldb database...")
redis_hostname = environ.get('REDIS_HOSTNAME','localhost')
redis_port = environ.get('REDIS_PORT',12000)
r = Redis(host=redis_hostname, port=redis_port, decode_responses=True)
print("Creating search schema.")
r.execute_command("FT.CREATE cases ON HASH PREFIX 1 amlcases: SCHEMA caseid TAG SORTABLE status TAG SORTABLE investigator TAG SORTABLE value NUMERIC SORTABLE files TAG SORTABLE date_reported NUMERIC SORTABLE date_last_updated NUMERIC SORTABLE report_body TEXT primary_acctno TAG SORTABLE phone TEXT NOSTEM ip TEXT NOSTEM account_details TEXT NOINDEX priority TAG SORTABLE related_tags TAG SORTABLE ssn TAG SORTABLE")
r.execute_command("FT.CREATE files ON HASH PREFIX 1 amlfiles: SCHEMA caseid TAG SORTABLE s3_url TEXT NOINDEX body TEXT filetype TAG SORTABLE date_added NUMERIC SORTABLE")

print("Search schema created.")
