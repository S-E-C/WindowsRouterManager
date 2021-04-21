@echo off
title 静态路由设置
color 0A
MODE con: COLS=88 lines=25

:isAdmin
echo.
Rd "%WinDir%\system32\test_permissions" >NUL 2>NUL
Md "%WinDir%\System32\test_permissions" 2>NUL||(Echo 请使用右键管理员身份运行！
echo.
echo.按任意键退出...&&Pause >nul&&Exit)
Rd "%WinDir%\System32\test_permissions" 2>NUL
echo.已取得管理员权限
echo.

:start
set myVpnIp=null
set userVpnIp=null
set aimIp=null
set mask=null
set routeNum=0

cls.
choice /c 1234 /m "1.添加静态路由 2.删除指定路由 3.查看路由表 4.连通测试"   
echo.
if %errorlevel% EQU 1 goto addRouteTable
if %errorlevel% EQU 2 goto deleteRouteTable
if %errorlevel% EQU 3 goto showRouteTable
if %errorlevel% EQU 4 goto testPing

:addRouteTable
goto showMyVpnIp
:showMyVpnIpFinish

goto setAimIp
:setAimIpFinish

goto setMask
:setMaskFinish

goto setUserVpnIp
:setUserVpnIpFinish

goto reConfirm
:reConfirmFinish

goto setRoute
:setRouteFinish

goto finish


::------------------------------------------函数模块----------------------------------------------
:setAimIp
set aimIp=null
set routeNum=0
set m=0
set /p aimIp=--------------------请输入目标网段:
echo.

if %aimIp% equ null (
echo.输入为空请重新输入
echo.
goto setAimIp)
::判断输入是否符合地址标准
set m=0
set n=0
set "ip_=%aimIp:.=;%"
for %%a in (%ip_%) do (
set/a n+=1
if %%a gtr 255 set m=1
if %%a lss 0 set m=1
)
if %n% neq 4 set m=1
if %m%==1 (  
echo.%aimIp% 不是标准的IP格式,请按任意键重新输入...             
echo. 
pause>nul
goto setAimIp
)

::判断目标route是否存在
for /f "tokens=*" %%i in ('route print ^|findstr %aimIp%') do (
	echo.已存在路由
	echo.%%i
	set /a routeNum+=1
)

if %routeNum% neq 0 (
echo. 
goto exist)
goto setAimIpFinish
::choice /c yn  /m "Y确认,N重新设置"
::echo.
::if %errorlevel% EQU 2 (
::goto setAimIp)
::if %errorlevel% EQU 1 (
::goto setAimIpFinish)

:exist
choice /c yn /m "路由表中已存在,是否删除"   
echo.
if %errorlevel% EQU 1 goto deleteRoute
if %errorlevel% EQU 2 goto setAimIp

:deleteRoute
route delete %aimIp%
echo.
echo.--------------------您输入目标网段是:%aimIp%
echo.
goto setAimIpFinish

:showMyVpnIp
for /f "tokens=16" %%i in ('ipconfig ^|find /i "ipv4"') do (
	echo\%%i| findstr 172 >nul && (
	set myVpnIp=%%i
	)
)
if %myVpnIp% equ null (
echo.您与云服务器VPN未连接,请在SoftEther中配置,具体请联系管理员
echo.
echo.请按任意键继续添加...
echo.
pause>nul
) else (
echo.--------------------您的VPN地址为:%myVpnIp%
echo.

)
goto showMyVpnIpFinish


:setUserVpnIp
set /p userVpnIp=--------------------请输入对端VPN地址：
echo.
if %userVpnIp% equ null (
echo.输入为空请重新输入
echo.
goto setUserVpnIp)

::判断输入是否符合地址标准
set m=0
set n=0
set "ip_=%userVpnIp:.=;%"
for %%a in (%ip_%) do (
set/a n+=1
if %%a gtr 255 set m=1
if %%a lss 0 set m=1
)
if %n% neq 4 set m=1
if %m%==1 (  
echo.%userVpnIp% 不是标准的IP格式,请按任意键重新输入               
echo. 
pause>nul
goto setUserVpnIp
)
goto setUserVpnIpFinish
::choice /c yn  /m "Y确认,N重新设置"
::echo.
::if %errorlevel% EQU 2 (
::goto setUserVpnIp)
::if %errorlevel% EQU 1 (
::goto setUserVpnIpFinish)

:setMask
set /p mask=--------------------请输入子网掩码地址：
echo.
if %mask% equ null (
echo.输入为空请重新输入
echo.
goto setMask)

::判断输入是否符合地址标准
set m=0
set n=0
set "ip_=%mask:.=;%"
for %%a in (%ip_%) do (
set/a n+=1
if %%a gtr 255 set m=1
if %%a lss 0 set m=1
)
if %n% neq 4 set m=1
if %m%==1 (  
echo.--------------------%mask% 不是标准的IP格式,请按任意键重新输入               
echo. 
pause>nul
goto setMask
)
goto setMaskFinish
::choice /c yn  /m "Y确认,N重新设置"
::echo.
::if %errorlevel% EQU 2 (
::goto setMask)
::if %errorlevel% EQU 1 (
::goto setMaskFinish)

:setRoute
route add %aimIp% mask %mask% %userVpnIp%
echo.
goto setRouteFinish

:reConfirm
echo.--------------------本机vpn地址:%myVpnIp%
echo.--------------------目标网段:%aimIp%
echo.--------------------子网掩码:%mask%
echo.--------------------对端vpn地址:%userVpnIp%
echo.
choice /c yr  /m "Y确认添加,R返回菜单"
echo.
if %errorlevel% EQU 2 (goto start) 
if %errorlevel% EQU 1 (goto reConfirmFinish)



:finish

:: /c按键列表 /m提示内容 /d默认选择 /t等待秒数   /d 必须和 /t同时出现
choice /c qr  /m "Q查看路由表,R返回菜单"
echo.
if %errorlevel% EQU 1 (
route print 
echo.
echo.请按任意键继续...
echo.
pause>nul  
goto finish)
if %errorlevel% EQU 2 goto start



:deleteRouteTable
set aimIp=null
set routeNum=0
set m=0
set /p aimIp=--------------------请输入要删除的目标网段:
echo.

if %aimIp% equ null (
echo.输入为空请重新输入
echo.
goto deleteRouteTable)
::判断输入是否符合地址标准
set m=0
set n=0
set "ip_=%aimIp:.=;%"
for %%a in (%ip_%) do (
set/a n+=1
if %%a gtr 255 set m=1
if %%a lss 0 set m=1
)
if %n% neq 4 set m=1
if %m%==1 (  
echo.%aimIp% 不是标准的IP格式,请按任意键重新输入...             
echo. 
pause>nul
goto deleteRouteTable
)

::判断目标route是否存在
for /f "tokens=*" %%i in ('route print ^|findstr %aimIp%') do (
	echo.删除路由
	echo.%%i
	set /a routeNum+=1
)
echo.

if %routeNum% neq 0 (
echo.删除目标网段为 %aimIp% 的路由
echo.

choice /c yr  /m "Y确认,R返回菜单"
echo.
goto chgErrcode
:chgErrcode
if %errorlevel% EQU 2 goto start
if %errorlevel% EQU 1 (
route delete %aimIp%
echo.
goto start
)
) else (
echo.不存在条目,按任意键返回菜单...
echo.
pause>nul
goto start
)

:showRouteTable
route print
echo.
echo.请按任意键返回菜单...
echo.
pause>nul
goto start

:testPing
set aimIp=null
set /p aimIp=--------------------请输入测试目标网址:
ping %aimIp%
echo.
echo.请按任意键返回菜单...
echo.
pause>nul
goto start

:end
exit
