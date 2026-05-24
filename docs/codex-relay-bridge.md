# Codex Desktop 通过 codex-relay 桥接 DeepSeek

## 架构概览

```
┌─────────────────┐      HTTP (OpenAI-compatible)      ┌──────────────┐      HTTPS       ┌──────────────────┐
│  Codex Desktop  │ ──────────────────────────────────→ │  codex-relay │ ──────────────→ │ api.deepseek.com │
│  (本地客户端)     │      http://127.0.0.1:4000/v1       │  (Rust 中间层) │                 │     /v1/...      │
└─────────────────┘                                     └──────────────┘                 └──────────────────┘
```

## 核心原理

**codex-relay** 是一个本地反向代理/协议适配层:

1. **Codex Desktop** 发出 OpenAI 兼容的 API 请求到 `http://127.0.0.1:4000/v1`
2. **codex-relay** 接收请求后转发到上游 `api.deepseek.com/v1`
3. 回程时 relay 将 DeepSeek 的响应包回 OpenAI 兼容格式

## codex-relay 处理的关键转换

| 场景 | DeepSeek 格式 | → OpenAI 格式 |
|------|--------------|---------------|
| 工具调用 | `function_call` | `tool_calls` |
| 推理内容 | `reasoning_content` | 透传（兼容字段） |
| 流式响应 | DeepSeek SSE | OpenAI-compatible SSE |
| 模型列表 | DeepSeek `/models` | 转换后 `/models` |

## 配置文件

### 1. Codex 配置 `~/.codex/config.toml`

```toml
model_provider = "deepseek"
model = "deepseek-v4-pro"
base_url = "http://127.0.0.1:4000/v1"
wire_api = "responses"
requires_openai_auth = false
stream_idle_timeout_ms = 600000
```

### 2. 认证文件 `~/.codex/auth.json`

```json
{
  "auth_mode": "apikey"
}
```

> 登录时用 DeepSeek API Key 即可

### 3. Relay 启动脚本 `relay/start-relay.bat`

```bat
@echo off
set CODEX_RELAY_UPSTREAM=https://api.deepseek.com
set CODEX_RELAY_API_KEY=sk-your-deepseek-key
set CODEX_RELAY_PORT=4000
start /min codex-relay
```

## 启动顺序（重要）

```
1. 启动 codex-relay (start-relay.bat → 监听 127.0.0.1:4000)
                ↓
2. 打开 Codex Desktop
                ↓
3. Codex → relay → DeepSeek 链路建立
```

> 必须先启动 relay，再打开 Codex，否则 Codex 无法连接后端

## 开机自启

快捷方式位置:
```
%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\codex-relay.lnk
```

## codex-relay 安装

```bash
pip install codex-relay
```

- 版本: v0.2.1
- 实现: Rust (编译后为 Python 包)
- 端口: 默认 4000

## 与 Claude Code 方案的区别

| | Codex Desktop (relay) | Claude Code (env vars) |
|---|---|---|
| 桥接方式 | codex-relay (本地代理) | ANTHROPIC_AUTH_TOKEN 环境变量 |
| 上游 | api.deepseek.com/v1 | api.deepseek.com/anthropic |
| 协议适配 | relay 自动转换 DeepSeek ↔ OpenAI | 直接 Anthropic 兼容调用 |
| 启动要求 | 必须先启 relay | 直接运行 |
| 适用场景 | Codex Desktop 原生体验 | 终端/CLI 编程 |
