@echo off
chcp 65001 >nul
title deep-claude-codex - Setup
color 0E

echo ============================================
echo   deep-claude-codex - One-Click Setup
echo   Claude Code + DeepSeek + Codex Integration
echo ============================================
echo.

:: ============================================
:: Step 1: Check Node.js
:: ============================================
echo [1/4] Checking Node.js...
where node >nul 2>&1
if %errorlevel% neq 0 (
    echo [FAIL] Node.js not found.
    echo.
    echo Please install Node.js first:
    echo   https://nodejs.org/  (LTS version recommended)
    echo   OR use nvm-windows: https://github.com/coreybutler/nvm-windows
    echo.
    pause
    exit /b 1
)
for /f "tokens=*" %%i in ('node -v') do set NODE_VERSION=%%i
echo [OK] Node.js %NODE_VERSION%

:: ============================================
:: Step 2: Check npm registry, auto-switch if needed
:: ============================================
echo.
echo [2/4] Checking npm registry connectivity...
npm ping >nul 2>&1
if %errorlevel% neq 0 (
    echo [INFO] npm registry unreachable, switching to npmmirror (China mirror)...
    npm config set registry https://registry.npmmirror.com
    npm ping >nul 2>&1
    if %errorlevel% neq 0 (
        echo [WARN] Mirror also unreachable. Trying with VPN/proxy may help.
        echo Continuing anyway...
    ) else (
        echo [OK] Switched to https://registry.npmmirror.com
    )
) else (
    echo [OK] npm registry reachable
)

:: ============================================
:: Step 3: Install Claude Code
:: ============================================
echo.
echo [3/4] Installing Claude Code CLI...
where claude >nul 2>&1
if %errorlevel% equ 0 (
    echo [OK] Claude Code already installed.
    for /f "tokens=*" %%i in ('claude --version') do echo   Version: %%i
) else (
    echo Installing @anthropic-ai/claude-code (this may take a minute)...
    call npm install -g @anthropic-ai/claude-code
    if %errorlevel% neq 0 (
        echo [FAIL] Claude Code installation failed.
        echo.
        echo Troubleshooting:
        echo   1. Check your network connection
        echo   2. Try: npm config set registry https://registry.npmmirror.com
        echo   3. Retry: npm install -g @anthropic-ai/claude-code
        echo.
        pause
        exit /b 1
    )
    echo [OK] Claude Code installed successfully.
)

:: ============================================
:: Step 4: Configure DeepSeek API Key
:: ============================================
echo.
echo [4/4] Configuring DeepSeek API...
echo.
echo You need a DeepSeek API key to use this tool.
echo Get one at: https://platform.deepseek.com/api_keys
echo.
set /p DEEPSEEK_KEY="Paste your DeepSeek API key (starts with sk-): "

if "%DEEPSEEK_KEY%"=="" (
    echo.
    echo [WARN] No key entered. You can set it later by editing deepclaude.bat
    echo         or by running setup.bat again.
    set DEEPSEEK_KEY=YOUR_DEEPSEEK_API_KEY_HERE
)

:: ============================================
:: Generate deepclaude.bat
:: ============================================
echo.
echo Generating deepclaude.bat...

(
echo @echo off
echo chcp 65001 ^>nul
echo color 0A
echo title deepclaude - DeepSeek V4
echo.
echo :: Add claude to PATH
echo set PATH=C:\Users\%USERNAME%\AppData\Roaming\npm;C:\Program Files\nodejs;%%PATH%%
echo.
echo :: DeepSeek API Configuration
echo set DEEPSEEK_API_KEY=%DEEPSEEK_KEY%
echo set ANTHROPIC_BASE_URL=https://api.deepseek.com/anthropic
echo set ANTHROPIC_AUTH_TOKEN=%%DEEPSEEK_API_KEY%%
echo.
echo :: Model mapping ^(Claude Code internals -^> DeepSeek models^)
echo set ANTHROPIC_DEFAULT_OPUS_MODEL=deepseek-v4-pro
echo set ANTHROPIC_DEFAULT_SONNET_MODEL=deepseek-v4-pro
echo set ANTHROPIC_DEFAULT_HAIKU_MODEL=deepseek-v4-flash
echo set CLAUDE_CODE_SUBAGENT_MODEL=deepseek-v4-flash
echo.
echo cls
echo echo ============================================
echo echo   deepclaude - Claude Code + DeepSeek V4
echo echo ============================================
echo echo.
echo echo  Endpoint: %%ANTHROPIC_BASE_URL%%
echo echo  Main model: deepseek-v4-pro
echo echo  Subagents: deepseek-v4-flash
echo echo.
echo echo  Starting Claude Code...
echo echo  Type /quit or press Ctrl+C to exit.
echo echo ============================================
echo echo.
echo.
echo call claude.cmd
echo.
echo echo.
echo echo  Session ended.
echo pause
) > deepclaude.bat

echo [OK] deepclaude.bat generated.

:: ============================================
:: Verify DeepSeek API reachable
:: ============================================
echo.
echo Verifying DeepSeek API connectivity...
powershell -Command "try { $r = Invoke-WebRequest -Uri 'https://api.deepseek.com/anthropic/v1/messages' -Method Options -TimeoutSec 10; Write-Host '[OK] DeepSeek API reachable' } catch { Write-Host '[WARN] Cannot reach DeepSeek API. Check your network/proxy settings.' }" 2>nul

:: ============================================
:: Done
:: ============================================
echo.
echo ============================================
echo   Setup Complete!
echo ============================================
echo.
echo   Files created: deepclaude.bat
echo.
echo   HOW TO USE:
echo.
echo   1. Double-click deepclaude.bat to start Claude Code
echo      (backed by DeepSeek V4 models)
echo.
echo   2. Or in Codex/terminal, tell your AI assistant:
echo      "Run claude -p 'your task here'"
echo.
echo   3. Integrate with GitHub Desktop for version control.
echo.
echo   Enjoy coding!
echo ============================================
echo.
pause
