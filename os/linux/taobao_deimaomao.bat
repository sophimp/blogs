@echo on
for /l %%i in (1,1,60) do (
    adb shell input tap 908 1689
    timeout /t 1
    adb shell input tap 960 1243
    timeout /t 12
    adb shell input tap 949 1168
    timeout /t 2
    adb shell input keyevent 4
    timeout /t 1
)
pause
