@echo off

:D
set ip=&set n=&set m=
set/p ip=��������Ҫ���͵�IP��ַ:
set "ip_=%ip:.=;%"
for %%a in (%ip_%) do (
set/a n+=1
if %%a gtr 255 set m=1
if %%a lss 0 set m=1
)
if %n% neq 4 set m=1
if %m%==1 (                   
echo.
echo %ip% ���Ǳ�׼��IP��ʽ,�밴�������������
pause>nul
goto:D
)

set myip=224.0.0.0
set num=0
for /f "tokens=*" %%i in ('route print ^|findstr %myip%') do (
	echo.%%i
	set /a num+=1
)
echo.���ĵ�ַ����Ϊ=%num%
echo.



pause