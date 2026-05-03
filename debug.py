import sqlite3

conn = sqlite3.connect("olist.db")

print(conn.execute("PRAGMA table_info(customers);").fetchall())
