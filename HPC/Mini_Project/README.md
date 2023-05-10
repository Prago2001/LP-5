Install  
`sudo apt install postgresql`  
`pip3 install psycopg`  
`sudo -u postgres psql -c "CREATE USER user_1 WITH SUPERUSER PASSWORD 'postgres';"`  
`sudo -u postgres psql -c 'create database test_1;'`  
`bzip2 -d employees_data.sql.bz2`    
Enter path of employees_data.sql in next command  
`psql test_1 < employees_data.sql -U user_1 -h localhost`  
Run jupyter notebook  

