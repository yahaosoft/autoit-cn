@echo off
color 0a
title Clean file
if not exist %cd%\txt2htm.ini goto :err
echo Clean file...
del *.log /f /s /q
del *.tmp /f /s /q
if exist %cd%\html\functions del %cd%\html\functions\*.htm /f /s /q
if exist %cd%\html\keywords del %cd%\html\keywords\*.htm /f /s /q
if exist %cd%\html\libfunctions del %cd%\html\libfunctions\*.htm /f /s /q
if exist %cd%\html\acnfunctions del %cd%\html\acnfunctions\*.htm /f /s /q
if exist %cd%\html\examples del %cd%\html\examples\*.htm /f /s /q
if exist %cd%\web\html\functions del %cd%\web\html\functions\*.* /f /s /q
if exist %cd%\web\html\keywords del %cd%\web\html\keywords\*.* /f /s /q
if exist %cd%\web\html\libfunctions del %cd%\web\html\libfunctions\*.* /f /s /q
if exist %cd%\web\html\acnfunctions del %cd%\web\html\acnfunctions\*.* /f /s /q
del _errorlog3.txt /f /q
del _errorlogUDF3.txt /f /q
del _errorlogM.txt /f /q
del _errorlogADF3.txt /f /q
del *.chm /f /q
del *.chw /f /q
echo All file Cleaned...PLZ press anykey to exit
pause >nul
exit

:err
echo 请在批处理所在目录调用我...
pause >nul