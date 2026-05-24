@echo off
chcp 65001 >nul

:: ============================================
:: deep-claude-codex / claude-run.bat
::
:: Non-interactive mode for Codex / terminal integration.
:: Usage: claude-run.bat "your prompt here"
::
:: Codex calls this with -p flag to run one-shot tasks.
:: Context is maintained by Codex across sessions.
:: ============================================

:: Add claude to PATH
set PATH=C:\Users\%USERNAME%\AppData\Roaming\npm;C:\Program Files\nodejs;%PATH%

:: DeepSeek API Configuration
set ANTHROPIC_BASE_URL=https://api.deepseek.com/anthropic

:: Load API key from file (if exists) or environment
if exist "%~dp0.env" (
    for /f "tokens=1,2 delims==" %%a in (%~dp0.env) do (
        if "%%a"=="DEEPSEEK_API_KEY" set DEEPSEEK_API_KEY=%%b
    )
)
if "%DEEPSEEK_API_KEY%"=="" (
    echo [ERROR] DEEPSEEK_API_KEY not set.
    echo Create a .env file with: DEEPSEEK_API_KEY=sk-xxx
    echo Or set the environment variable before running.
    exit /b 1
)

set ANTHROPIC_AUTH_TOKEN=%DEEPSEEK_API_KEY%

:: Model mapping
set ANTHROPIC_DEFAULT_OPUS_MODEL=deepseek-v4-pro
set ANTHROPIC_DEFAULT_SONNET_MODEL=deepseek-v4-pro
set ANTHROPIC_DEFAULT_HAIKU_MODEL=deepseek-v4-flash
set CLAUDE_CODE_SUBAGENT_MODEL=deepseek-v4-flash

:: Run Claude Code in print (non-interactive) mode
if "%~1"=="" (
    echo Usage: claude-run.bat "your task description"
    echo Example: claude-run.bat "Add a search endpoint to main.py"
    exit /b 1
)

claude -p "%~1"
