import json
import psycopg2
import sys
import boto3
import os

def lambda_handler(event, context):
    print(event)
    ENDPOINT=event['endpoint']
    PORT="5432"
    USR="postgres"
    REGION="us-east-1"
    DBNAME="postgres"
    pwd=event['password']
    conn = psycopg2.connect(host=ENDPOINT, port=PORT, database=DBNAME, user=USR, password=pwd)
    cur = conn.cursor()
    cur.execute("""create user dbdeveloper with createdb;""")
    cur.execute("""grant rds_iam to dbdeveloper;""")
    conn.commit()
    cur.execute("""select * from pg_user""")
    query_results = cur.fetchall()
    print(query_results)
    return {
        'statusCode': 200
        }
