import sqlite3,os,pandas as pd
conn=sqlite3.connect('olist.db')
for f in sorted(os.listdir('sql')):
 if f.endswith('.sql'):
  sql=open('sql/'+f).read()
  conn.executescript(sql)
  try:
   df=pd.read_sql(sql.split(';')[-2],conn)
   df.to_csv('results/'+f.replace('.sql','.csv'),index=False)
  except:pass
print('done')
