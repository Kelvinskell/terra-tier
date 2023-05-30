import os
from venv import create
from dotenv import load_dotenv
load_dotenv()
import mysql.connector

# Define SQL Queries
USER = os.getenv('MYSQL_USER')
HOST = os.getenv('MYSQL_HOST')
DB = os.getenv('MYSQL_DB')
PASSWORD = os.getenv('DATABASE_PASSWORD')
SHOW_DB = "SHOW DATABASES"
SHOW_TB = "SHOW TABLES"
CREATE_TABLE = """
CREATE TABLE user(
    id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(30),
    email_address VARCHAR(30),
    password BLOB(1000)
)
"""

# Connect to MYSQL server and create database
def create_database():
    # Create Database if not existing
    try:
        with mysql.connector.connect(
                host=HOST,
                user=USER,
                password=PASSWORD
        ) as connection:
            with connection.cursor() as cursor:
                cursor.execute(SHOW_DB)
                dbs = [db[0] for db in cursor]
                if DB not in dbs:
                    create_db = f"CREATE DATABASE {DB}"
                    with connection.cursor() as cursor:
                        cursor.execute(create_db)
                else:
                    return False
        return True
    except mysql.connector.Error as e :
        print(e)
        
        return False

def create_table():
    # Create Table if not existing
    if not create_database():
        return False
    try:
        with mysql.connector.connect(
            host=HOST,
            user=USER,
            password=PASSWORD,
            database=DB
        ) as connection:
          with connection.cursor() as cursor:
            cursor.execute(SHOW_TB)
            tbs = [tb[0] for tb in cursor]

            # Create Tables
            with connection.cursor() as cursor:
                if 'user' not in tbs:
                    cursor.execute(CREATE_TABLE)
            return True

    except mysql.connector.Error as e:
        print(e)
    

create_table()