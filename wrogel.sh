#!/bin/bash

#ВВЕСТИ ПУТЬ К ИСКОМОМУ ЛОГУ:
dwl=/var/log/XXXXXXXXXXX/XXXXXX.log




s1=$1 #id события
s2=$2 #err

p1="/root/wrogel"
events=$p1/job/event$s1".txt"
pp=$p1/list_mail$s1".txt"
log=/var/log/wrogel.txt
path=$p1/list_lc.txt
tempf=$p1/tmp/

tempf1=""; t_end_str1=""

if ! [ -f $log ]; then
echo " " > $log
else
echo " " >> $log
fi

date1=`date '+ %d.%m.%Y %H:%M:%S'`; echo $date1 " wrogel: starting wrogel" >> $log
str1=""
str0="grep -n "$(sed -n "1p" $events |tr -d '\r')" "$dwl" "
col="`wc -l $events | sed -r 's/ .+//' | sed 's/[ \t]*$//'`"
for (( i=0;i<=$col;i++)); do
if [ "$i" -gt "1" ]; then
dg=$(sed -n ${i}"p" $events |tr -d '\r')
str1=$str1"| grep \""$dg"\" "
fi
done
str1=$str0$str1
echo $date1 " wrogel: eval grep ="$str1 >> $log



poster () {
for x in `cat $pp|grep -v \#`
do
	echo $date1 " wrogel: ATTACH="$ATTACH >> $log 
	echo -e $s2" - "$h"\n"$t_end_str" - "$dg".\n\n\nЭто автоматическая рассылка, отвечать незачем.\n" | mutt -s "Error app "$s1" in "$h -a $ATTACH -- $x
	date1=`date '+ %d.%m.%Y %H:%M:%S'`; echo $date1 " wrogel: post mail "$x >> $log
done
}

all_invait () {
		echo $date1 " wrogel: all_invait " >> $log
		ATTACH=$tempf1$s1".txt"
		cat $tempf1$s1".txt"|tail -1 > $tempf1$s1"_end.txt"
		t_end_str=$(cat $tempf1$s1"_end.txt"|tail -1 | awk '{print $1,$2}' | awk 'BEGIN{FS=":"; OFS=":"} {print $2,$3,$4}' | sed 's/^[ \t]*//;s/[ \t]*$//' | tr -d '\r')
		echo $date1 " wrogel: t_end_str= "$t_end_str >> $log
		post=1
}


colstring () {

	col_str1="`wc -l $tempf1$s1".txt" | sed -r 's/ .+//' | sed 's/[ \t]*$//'`"
	echo $date1 " wrogel: col_str1="$col_str1 >> $log
	
	if [ $col_str1 -gt 0 ]; then
	if [ -f $tempf1$s1"_end.txt" ]; then	#------end
		echo $date1 " wrogel: file_end+ " >> $log
		t_end_str=$(cat $tempf1$s1"_end.txt"|tail -1 | awk '{print $1,$2}' | awk 'BEGIN{FS=":"; OFS=":"} {print $2,$3,$4}' | sed 's/^[ \t]*//;s/[ \t]*$//' | tr -d '\r')
		echo $date1 " wrogel: t_end_str="$t_end_str >> $log
		
		result=$(grep -n "$t_end_str" $tempf1$s1".txt" | cut -d : -f 1)
		echo $date1 " wrogel: result="$result >> $log
		if [ "$result" -eq "0" ]; then
		all_invait;
		fi
		if [ "$result" -lt "$col_str1" ]; then
		col1=$((col_str1-result))
		cat $tempf1$s1".txt" | tail -$col1 > $tempf1$s1"_tmp.txt"
		cp $tempf1$s1"_tmp.txt" $tempf1$s1".txt"
		all_invait;
		fi
	else
		echo $date1 " wrogel: file_end-" >> $log
		all_invait;
		
	fi	#------end
	fi
}


for h in `cat $path|tr -d '\r'`	
do
mkdir -p $tempf$h
tempf1=$tempf$h"/"
post=0
date1=`date '+ %d.%m.%Y %H:%M:%S'`; echo $date1 " wrogel: connect "$h >> $log

echo "------------------"$h

if [ -f $tempf1$s1"_size.txt" ]; then
size=$(sed -n "1p" $tempf1$s1"_size.txt" | tr -d '\r')
else
size=0
fi
date1=`date '+ %d.%m.%Y %H:%M:%S'`; echo $date1 " wrogel: size="$size >> $log

if eval "ping -c 2 $h"; then
date1=`date '+ %d.%m.%Y %H:%M:%S'`; echo $date1 " wrogel: start find "$h >> $log
$p1/ssh-21.sh $h eval $str1  > $tempf1$s1".txt"
$p1/ssh-21.sh $h stat $dwl | grep 'Размер' | awk '{print $2}' > $tempf1$s1$s1".txt"

size1=$(sed -n "1p" $tempf1$s1$s1".txt" | tr -d '\r')
#size1=$((size+100))
date1=`date '+ %d.%m.%Y %H:%M:%S'`; echo $date1 " wrogel: size1="$size1 >> $log

if [ "$size1" -ge "$size" ]; then	#------size
date1=`date '+ %d.%m.%Y %H:%M:%S'`; echo $date1 " wrogel: size1>=size" >> $log
colstring;
else
date1=`date '+ %d.%m.%Y %H:%M:%S'`; echo $date1 " wrogel: size1<size "$h >> $log
rm -f $tempf1$s1$s1".txt"
rm -f $tempf1$s1"_end.txt"
colstring;

fi	#------size
echo $size1 > $tempf1$s1"_size.txt"

else
date1=`date '+ %d.%m.%Y %H:%M:%S'`; echo $date1 " wrogel: no ping "$h >> $log
fi


echo "------------------"$h
if [ "$post" -eq "1" ]; then poster; fi;
done

date1=`date '+ %d.%m.%Y %H:%M:%S'`; echo $date1 " wrogel: stop wrogel" >> $log

