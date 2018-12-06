#!/bin/bash

# 循环总次数
totalDegree=$1

# 如果没有传参，则默认值是 10
if [ "$totalDegree" = "" ];
then
    totalDegree=10
fi

for((timeTemp = 0; timeTemp <= $totalDegree; timeTemp = timeTemp + 5))
do
    echo "timeTemp=$timeTemp"
done



