@echo off

:D
set ip=&set n=&set m=
set/p ip=请输入需要发送的IP地址:
set "ip_=%ip:.=;%"
for %%a in (%ip_%) do (
set/a n+=1
if %%a gtr 255 set m=1
if %%a lss 0 set m=1
)
if %n% neq 4 set m=1
if %m%==1 (                   
echo.
echo %ip% 不是标准的IP格式,请按任意键重新输入
pause>nul
goto:D
)

set myip=224.0.0.0
set num=0
for /f "tokens=*" %%i in ('route print ^|findstr %myip%') do (
	echo.%%i
	set /a num+=1
)
echo.您的地址个数为=%num%
echo.



pause