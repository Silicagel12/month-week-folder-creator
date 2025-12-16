@echo off
chcp 65001 >nul

REM make month-week folder by monday to sunday
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0WeekFolderCreator.ps1"

echo.
echo 실행이 끝났습니다. 오류가 있으면 위 메시지를 확인하세요.
pause

