#!/bin/bash
# 如果进程中没有nginx则将keepalived进程kill掉
A=`ps -C nginx --no-header |wc -l`      ## 查看是否有 nginx进程 把值赋给变量A 
if [ $A -eq 0 ];then                    ## 如果没有进程值得为 零
       service keepalived stop          ## 则结束 keepalived 进程
fi