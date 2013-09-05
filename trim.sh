#!/bin/bash
start_line_col=`cat -n $1 | grep "# col_name" | awk {'print $1'} | head -1`
end_line_col=`cat -n $1 | grep "# Partition Information" | awk {'print $1'} | head -1`
pstart=`expr $end_line_col + 3`;
end=`cat -n $1 | grep "# Detailed Table Information" | awk {'print $1'} | head -1`
pend=`expr $end - 2`;
echo "pstart=$pstart and pend=$pend ";
echo "Start line is $start_line_col";
echo "End line is $end_line_col";
start_line_col=`expr $start_line_col + 2`;
echo $start_line_col
end_line_col_last=`expr $end_line_col - 2`;
end_line_col_last_before=`expr $end_line_col - 3`;
echo $end_line_col
echo "create table $2(" > $2.hql
sed -n ""$start_line_col","$end_line_col_last_before"p" $1 | awk {'print $1" "$2" ,"'} >> $2.hql
sed -n ""$end_line_col_last"p" $1 | awk {'print $1" "$2'}  >> $2.hql
echo ")" >> $2.hql
echo "sed -n ""$pstart","$pend"p" $1 | awk ' {print $1" "$2}' | tr '\n' ','";
PART=`sed -n ""$pstart","$pend"p" $1 | awk ' {print $1" "$2}' | tr '\n' ','` 
echo "PART=$PART"
PARTITIONS=`echo $PART | sed '$s/.$//'`
echo "PARTITIONED BY ($PARTITIONS)" >> $2.hql
echo "ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\n' STORED AS TEXTFILE;" >> $2.hql


