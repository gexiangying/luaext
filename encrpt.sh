#!/bin/sh
luas=`ls bin/*.lua`
for lua in $luas 
do
bin/luac5.1 -o $lua $lua
done
