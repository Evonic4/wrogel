#!/bin/bash

f1=/root/wrogel/
cd $f1
ls | sed -n '/.sh/p' | sed 's/setup.sh//g' | sed '/^$/d' > $f1"fs"

for x in `cat $f1"fs"|grep -v \#`
do
chmod +rx $x
perl -pi -e "s/\r\n/\n/" $x
echo $x
done
