@echo off
chcp 65001 >nul
title codex-relay

:: ============================================
:: codex-relay startup script
:: Bridges Codex Desktop to DeepSeek API.
:: ============================================

:: Configuration - edit your API key below
set CODEX_RELAY_UPSTREAM=https://api.deepseek.com
set CODEX_RELAY_API_KEY=YOUR_DEEPSEEK_API_KEY_HERE
set CODEX_RELAY_PORT=4000

echo ============================================
echo   codex-relay - DeepSeek Bridge
echo ============================================
echo.
echo  Port: %CODEX_RELAY_PORT%
echo  Upstream: %CODEX_RELAY_UPSTREAM%
echo.
echo  Starting relay...
echo.

start /min codex-relay

echo  Relay started in background.
echo  Now open Codex Desktop.
echo.
echo  To stop: taskkill /f /im codex-relay.exe
echo.
pause
