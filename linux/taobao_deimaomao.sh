#!/bin/bash

# 华为p20, 淘宝赢猫币脚本
for (( i=1; i<=60; i++ ))
do
    adb shell input tap 908 1689
    sleep 1
    adb shell input tap 960 1243
    sleep 12
    adb shell input tap 949 1168
    sleep 2
    adb shell input keyevent 4
    sleep 1
done
