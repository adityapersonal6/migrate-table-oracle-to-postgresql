#!/bin/bash

# Oracle Database Connection Details
oracle_host="oracle_host"
oracle_port="oracle_port"
oracle_service_name="oracle_service_name"
oracle_user="oracle_user"
oracle_password="oracle_password"

# PostgreSQL Database Connection Details
postgresql_host="postgresql_host"
postgresql_port="postgresql_port"
postgresql_database="postgresql_database"
postgresql_user="postgresql_user"
postgresql_password="postgresql_password"

# SQL Query to retrieve data from Oracle
sql_query="SELECT column1, column2, column3 FROM your_table"

# Output CSV file path
csv_file_path="output.csv"

# Oracle connection string
oracle_connection_string="${oracle_user}/${oracle_password}@//${oracle_host}:${oracle_port}/${oracle_service_name}"

# Export data from Oracle to CSV
sqlplus -S "$oracle_connection_string" <<EOF
SET MARKUP CSV ON DELIMITER ',' QUOTE ON
SET NUMFORMAT 999999999999999999999999999999999999999999999999999999999999
SET SPOOLING ON
SPOOL ${csv_file_path}
${sql_query};
SPOOL OFF
EXIT
EOF

# Import CSV into PostgreSQL
psql -h "$postgresql_host" -p "$postgresql_port" -d "$postgresql_database" -U "$postgresql_user" -c "\copy your_table FROM '${csv_file_path}' CSV HEADER"

# Check if import was successful
if [ $? -eq 0 ]; then
  echo "Data migration successful!"
else
  echo "Error occurred during data migration."
fi
