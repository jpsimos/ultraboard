@echo off

set SDT_SCRIPT=sdt_script.tcl
set DT_SCRIPT=dt_script.tcl
set FSBL_SCRIPT=fsbl_script.tcl
set DESIGN_FILE=ultraboard_design_wrapper.xsa

:menu
echo ----------------------------------------------
echo generate components menu
echo ----------------------------------------------
echo [1] SDT + FSBL
echo [2] SDT
echo [3] FSBL
echo [4] DT
echo [5] Exit
echo ----------------------------------------------
choice /c 1234 /n /m "Select an option (1-4): "
if errorlevel 5 goto exit
if errorlevel 4 goto choice_dt
if errorlevel 3 goto choice_fsbl
if errorlevel 2 goto choice_sdt
if errorlevel 1 goto choice_both
goto menu

:choice_both
start "SDT Generation" /I /B /WAIT /D %~dp0 cmd.exe /C "C:\Xilinx\Vitis\2024.2\bin\xsct.bat" %SDT_SCRIPT% %DESIGN_FILE% ./sdt
if %ERRORLEVEL% NEQ 0 goto choice_exit
start "FSBL Generation" /I /B /WAIT /D %~dp0 cmd.exe /C "C:\Xilinx\Vitis\2024.2\bin\xsct.bat" %FSBL_SCRIPT% %DESIGN_FILE% ./fsbl
goto choice_exit

:choice_sdt
start "SDT Generation" /I /B /WAIT /D %~dp0 cmd.exe /C "C:\Xilinx\Vitis\2024.2\bin\xsct.bat" %SDT_SCRIPT% %DESIGN_FILE% ./sdt
goto choice_exit

:choice_fsbl
start "FSBL Generation" /I /B /WAIT /D %~dp0 cmd.exe /C "C:\Xilinx\Vitis\2024.2\bin\xsct.bat" %FSBL_SCRIPT% %DESIGN_FILE% ./fsbl
goto choice_exit

:choice_dt
start "DT Generation" /I /B /WAIT /D %~dp0 cmd.exe /C "C:\Xilinx\Vitis\2024.2\bin\xsct.bat" %DT_SCRIPT% %DESIGN_FILE% ./dt
goto choice_exit

:choice_exit
if %ERRORLEVEL% NEQ 0 (
	set RESULT=%ERRORLEVEL%
	pause
	exit /B %RESULT%
)

pause