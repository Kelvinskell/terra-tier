import secrets
from flask import Flask
from flask import render_template
import pymysql
pymysql.install_as_MySQLdb()
from flask_mysqldb import MySQL
import os
from dotenv import load_dotenv
load_dotenv()

app = Flask(__name__)
app.config['SECRET_KEY'] = os.getenv('SECRET_KEY')
app.config['MYSQL_DB'] = os.getenv('MYSQL_DB')
app.config['MYSQL_USER'] = os.getenv('MYSQL_USER')
app.config['MYSQL_HOST'] = os.getenv('MYSQL_HOST')
app.config['MYSQL_PASSWORD'] = os.getenv('DATABASE_PASSWORD')
app.config['MYSQL_ROOT_PASSWORD'] = os.getenv('MYSQL_ROOT_PASSWORD')

mysql = MySQL(app)


from application import routes