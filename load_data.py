import os,sqlite3,pandas as pd
DB='olist.db'
DATA='data'
FILES={'olist_customers_dataset.csv':'customers','olist_orders_dataset.csv':'orders','olist_order_items_dataset.csv':'order_items','olist_order_payments_dataset.csv':'order_payments'}
if os.path.exists(DB):os.remove(DB)
conn=sqlite3.connect(DB)
for f,t in FILES.items():
 p=os.path.join(DATA,f)
 if not os.path.exists(p):print('Missing',f);continue
 df=pd.read_csv(p)
 for col in df.columns:
  if 'date' in col or 'timestamp' in col:
   df[col]=pd.to_datetime(df[col],errors='coerce').astype(str)
 df.to_sql(t,conn,if_exists='replace',index=False)
 print('Loaded',t)
print('DB ready')
