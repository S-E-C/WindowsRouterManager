@echo off
title ��̬·������
color 0A
MODE con: COLS=88 lines=25

:isAdmin
echo.
Rd "%WinDir%\system32\test_permissions" >NUL 2>NUL
Md "%WinDir%\System32\test_permissions" 2>NUL||(Echo ��ʹ���Ҽ�����Ա������У�
echo.
echo.��������˳�...&&Pause >nul&&Exit)
Rd "%WinDir%\System32\test_permissions" 2>NUL
echo.��ȡ�ù���ԱȨ��
echo.

:start
set myVpnIp=null
set userVpnIp=null
set aimIp=null
set mask=null
set routeNum=0

cls.
choice /c 1234 /m "1.��Ӿ�̬·�� 2.ɾ��ָ��·�� 3.�鿴·�ɱ� 4.��ͨ����"   
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


::------------------------------------------����ģ��----------------------------------------------
:setAimIp
set aimIp=null
set routeNum=0
set m=0
set /p aimIp=--------------------������Ŀ������:
echo.

if %aimIp% equ null (
echo.����Ϊ������������
echo.
goto setAimIp)
::�ж������Ƿ���ϵ�ַ��׼
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
echo.%aimIp% ���Ǳ�׼��IP��ʽ,�밴�������������...             
echo. 
pause>nul
goto setAimIp
)

::�ж�Ŀ��route�Ƿ����
for /f "tokens=*" %%i in ('route print ^|findstr %aimIp%') do (
	echo.�Ѵ���·��
	echo.%%i
	set /a routeNum+=1
)

if %routeNum% neq 0 (
echo. 
goto exist)
goto setAimIpFinish
::choice /c yn  /m "Yȷ��,N��������"
::echo.
::if %errorlevel% EQU 2 (
::goto setAimIp)
::if %errorlevel% EQU 1 (
::goto setAimIpFinish)

:exist
choice /c yn /m "·�ɱ����Ѵ���,�Ƿ�ɾ��"   
echo.
if %errorlevel% EQU 1 goto deleteRoute
if %errorlevel% EQU 2 goto setAimIp

:deleteRoute
route delete %aimIp%
echo.
echo.--------------------������Ŀ��������:%aimIp%
echo.
goto setAimIpFinish

:showMyVpnIp
for /f "tokens=16" %%i in ('ipconfig ^|find /i "ipv4"') do (
	echo\%%i| findstr 172 >nul && (
	set myVpnIp=%%i
	)
)
if %myVpnIp% equ null (
echo.�����Ʒ�����VPNδ����,����SoftEther������,��������ϵ����Ա
echo.
echo.�밴������������...
echo.
pause>nul
) else (
echo.--------------------����VPN��ַΪ:%myVpnIp%
echo.

)
goto showMyVpnIpFinish


:setUserVpnIp
set /p userVpnIp=--------------------������Զ�VPN��ַ��
echo.
if %userVpnIp% equ null (
echo.����Ϊ������������
echo.
goto setUserVpnIp)

::�ж������Ƿ���ϵ�ַ��׼
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
echo.%userVpnIp% ���Ǳ�׼��IP��ʽ,�밴�������������               
echo. 
pause>nul
goto setUserVpnIp
)
goto setUserVpnIpFinish
::choice /c yn  /m "Yȷ��,N��������"
::echo.
::if %errorlevel% EQU 2 (
::goto setUserVpnIp)
::if %errorlevel% EQU 1 (
::goto setUserVpnIpFinish)

:setMask
set /p mask=--------------------���������������ַ��
echo.
if %mask% equ null (
echo.����Ϊ������������
echo.
goto setMask)

::�ж������Ƿ���ϵ�ַ��׼
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
echo.--------------------%mask% ���Ǳ�׼��IP��ʽ,�밴�������������               
echo. 
pause>nul
goto setMask
)
goto setMaskFinish
::choice /c yn  /m "Yȷ��,N��������"
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
echo.--------------------����vpn��ַ:%myVpnIp%
echo.--------------------Ŀ������:%aimIp%
echo.--------------------��������:%mask%
echo.--------------------�Զ�vpn��ַ:%userVpnIp%
echo.
choice /c yr  /m "Yȷ�����,R���ز˵�"
echo.
if %errorlevel% EQU 2 (goto start) 
if %errorlevel% EQU 1 (goto reConfirmFinish)



:finish

:: /c�����б� /m��ʾ���� /dĬ��ѡ�� /t�ȴ�����   /d ����� /tͬʱ����
choice /c qr  /m "Q�鿴·�ɱ�,R���ز˵�"
echo.
if %errorlevel% EQU 1 (
route print 
echo.
echo.�밴���������...
echo.
pause>nul  
goto finish)
if %errorlevel% EQU 2 goto start



:deleteRouteTable
set aimIp=null
set routeNum=0
set m=0
set /p aimIp=--------------------������Ҫɾ����Ŀ������:
echo.

if %aimIp% equ null (
echo.����Ϊ������������
echo.
goto deleteRouteTable)
::�ж������Ƿ���ϵ�ַ��׼
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
echo.%aimIp% ���Ǳ�׼��IP��ʽ,�밴�������������...             
echo. 
pause>nul
goto deleteRouteTable
)

::�ж�Ŀ��route�Ƿ����
for /f "tokens=*" %%i in ('route print ^|findstr %aimIp%') do (
	echo.ɾ��·��
	echo.%%i
	set /a routeNum+=1
)
echo.

if %routeNum% neq 0 (
echo.ɾ��Ŀ������Ϊ %aimIp% ��·��
echo.

choice /c yr  /m "Yȷ��,R���ز˵�"
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
echo.��������Ŀ,����������ز˵�...
echo.
pause>nul
goto start
)

:showRouteTable
route print
echo.
echo.�밴��������ز˵�...
echo.
pause>nul
goto start

:testPing
set aimIp=null
set /p aimIp=--------------------���������Ŀ����ַ:
ping %aimIp%
echo.
echo.�밴��������ز˵�...
echo.
pause>nul
goto start

:end
exit
