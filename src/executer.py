import sqlite3
import pandas as pd
import datetime

dt_start = '2021-12-01'
dt_stop = '2021-12-15'
fs_name = 'featAssinatura'

def import_query(path):
    with open(path, 'r') as file:
        query = file.read()
    return query

def table_exists(database, table_name):
    cursor = database.cursor()
    sql_query = """SELECT name FROM sqlite_master WHERE type='table'"""
    cursor = cursor.execute(sql_query)
    table_info = list(cursor.fetchall())

    if (table_name,) in table_info:
        return True
    return False

def date_range(start, stop):
    dt_start = datetime.datetime.strptime(start, "%Y-%m-%d")
    dt_stop = datetime.datetime.strptime(stop, "%Y-%m-%d")

    list_date = []
    while dt_start <= dt_stop:
        list_date.append(dt_start.strftime("%Y-%m-%d"))
        dt_start += datetime.timedelta(days=1)


    return list_date

database_origin = sqlite3.connect('data/bronze_gc.db')
database_target = sqlite3.connect('data/silver_gc.db')

query_structure = import_query(f'src/feature_store/{fs_name}.sql')

for date in date_range(dt_start, dt_stop):
    query_exec = query_structure.format(date=date)
    pd.read_sql(query_exec, database_origin).to_sql("featAssinatura", database_target, if_exists='append')