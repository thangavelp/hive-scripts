#!/bin/bash
:' COMMENT This script reads a file that contains table names and calls another script called describe_table.sh which descripes and stores the output in a file <table_name>.raw . 
After creating raw file. That file is passed as input to another script create_hive_schema.sh - which takes a raw file and table name as input and generates a file with <table_name>.hql  which contains the schema of that particular table.

Note :: This works for Partioned tables in particular
'

if (( test -f table_names )); then
	echo "exists"
else 
	echo -e "Input file dosent exist..! \nStopping Execution.... \nPlease have a input file <table_names> with hive table names in same location";
	exit;
fi

while read table_name
do
	echo "Creating Schema for table - $p"
	sh describe_table.sh $table_name > $table_name.raw
	echo "Output of raw file ";
	cat $table_name.raw
	sh trim.sh $table_name.raw $table_name
	rm $table_name.raw
done < table_names
