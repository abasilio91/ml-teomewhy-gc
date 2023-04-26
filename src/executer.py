import sqlite3
import pandas as pd
import datetime

dt_start = '2021-11-01'
dt_stop = '2022-02-28'
fs_name = ['featAssinatura','featGamePlay','featMedals']

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

for feature in fs_name:
    if table_exists(database_target, feature):
        database_target.cursor().execute(f"drop table {feature}")

    query_structure = import_query(f'src/feature_store/{feature}.sql')

    for date in date_range(dt_start, dt_stop):
        query_exec = query_structure.format(date=date)
        pd.read_sql(query_exec, database_origin).to_sql(feature, database_target, if_exists='append', index=False)
