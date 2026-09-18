@echo off
chcp 65001 >nul
echo.
echo 若历史记录在「换打开方式」后看不见，数据可能还在浏览器旧地址里。
echo 将打开本目录下的 html（旧入口），请查看是否还有任务。
echo.
echo 若能看到数据：请在页面底部「导出 JSON」，再用「启动.bat」打开后导入。
echo.

start "" "%~dp0priority.html"
echo.
pause
