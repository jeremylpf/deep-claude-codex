@echo off
chcp 65001 >nul
color 0A
title deepclaude - DeepSeek V4

:: Add claude to PATH
set PATH=C:\Users\%USERNAME%\AppData\Roaming\npm;C:\Program Files\nodejs;%PATH%

:: ============================================
:: DeepSeek API Configuration
:: Edit your key below, or run setup.bat again
:: ============================================
set DEEPSEEK_API_KEY=YOUR_DEEPSEEK_API_KEY_HERE
set ANTHROPIC_BASE_URL=https://api.deepseek.com/anthropic
set ANTHROPIC_AUTH_TOKEN=%DEEPSEEK_API_KEY%

:: ============================================
:: Model Mapping
:: Claude Code uses Opus/Sonnet/Haiku internally.
:: We route all of them to DeepSeek models.
:: ============================================
set ANTHROPIC_DEFAULT_OPUS_MODEL=deepseek-v4-pro
set ANTHROPIC_DEFAULT_SONNET_MODEL=deepseek-v4-pro
set ANTHROPIC_DEFAULT_HAIKU_MODEL=deepseek-v4-flash
set CLAUDE_CODE_SUBAGENT_MODEL=deepseek-v4-flash

cls
echo ============================================
echo   deepclaude - Claude Code + DeepSeek V4
echo ============================================
echo.
echo  Endpoint: %ANTHROPIC_BASE_URL%
echo  Main model: deepseek-v4-pro
echo  Subagents: deepseek-v4-flash
echo.
echo  Starting Claude Code...
echo  (First run may ask you to accept terms)
echo.
echo  Type /quit or press Ctrl+C to exit.
echo ============================================
echo.

call claude.cmd

echo.
echo  Session ended.
pause
