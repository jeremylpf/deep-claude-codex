# deep-claude-codex

> Windows 一键搭建：Codex Desktop + Claude Code + DeepSeek，中国用户的开源 AI 编程方案。

[中文](#chinese) | [English](#english)

---

<a name="chinese"></a>
## 中文

### 三条路径

本项目提供三种方式在 Windows 上使用 DeepSeek 驱动 AI 编程：

`
方案 A: Codex Desktop  codex-relay  DeepSeek (推荐日常使用)
方案 B: Codex 终端  Claude Code CLI  DeepSeek (终端编程)
方案 C: Codex 终端  设置 ANTHROPIC_BASE_URL  直接调 DeepSeek API (零中间层)
`

| | 方案 A: codex-relay | 方案 B: Claude Code CLI | 方案 C: 直接调 DeepSeek API |
|---|---|---|---|
| 桥接方式 | 本地代理 (127.0.0.1:4000) | 环境变量 | 环境变量 (无 relay) |
| 启动要求 | 先启 relay → 再开 Codex | 直接运行 bat | Codex 设 env vars 后调 claude -p |
| 适用场景 | Codex Desktop 原生体验 | 交互式终端编程 | 自动化编程 + Git 管理 |
| 协议转换 | relay 自动转换 | Anthropic 兼容接口 | Anthropic 兼容接口（直连）

---

### 方案 A：Codex Desktop + codex-relay（推荐）

通过本地代理把 Codex Desktop 的 OpenAI 协议请求转成 DeepSeek 格式。

`
Codex Desktop  127.0.0.1:4000  codex-relay  api.deepseek.com
`

#### 安装步骤

\\\ash
# 1. 安装 codex-relay
pip install codex-relay

# 2. 复制配置文件
copy relay\config.toml %USERPROFILE%\.codex\config.toml
copy relay\auth.json %USERPROFILE%\.codex\auth.json

# 3. 编辑 relay\start-relay.bat，填入你的 DeepSeek API key

# 4. 启动 relay
relay\start-relay.bat

# 5. 打开 Codex Desktop
\\\

> 必须先启动 relay，再打开 Codex。详细文档见 [docs/codex-relay-bridge.md](docs/codex-relay-bridge.md)

#### 开机自启

将 elay\start-relay.bat 快捷方式放入：
\\\
%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\
\\\

---

### 方案 B：Codex 终端 + Claude Code CLI

Codex 终端直接调用 Claude Code，底座指向 DeepSeek。Codex 维护项目长期上下文，Claude Code 负责单次编码任务。

#### 安装步骤

\\\at
:: 1. 运行一键安装
setup.bat

:: 2. 将 .env.example 复制为 .env，填入 key
copy .env.example .env

:: 3. 在 Codex 终端中调用
claude-run.bat "你的编程任务"
\\\

#### Codex 终端调用方式

\\\powershell
# 方式 1：通过 claude-run.bat
& "path\to\claude-run.bat" "给 main.py 添加搜索接口"

# 方式 2：直接设环境变量
$env:ANTHROPIC_BASE_URL = "https://api.deepseek.com/anthropic"
$env:ANTHROPIC_AUTH_TOKEN = "sk-你的key"
claude -p "你的任务"
\\\

#### 完整工作流

\\\
你：「给 demo-app 加用户注册接口」
      
Codex 读项目上下文  拼好 prompt
      
Codex 执行：claude-run.bat "在 main.py 中添加 POST /register..."
      
Claude Code (DeepSeek V4)  读代码  写代码  返回
      
Codex 审查 git diff  git commit
      
下次继续，Codex 记得全部历史
\\\

---

### 网络说明

| 服务 | 需要 VPN？ | 说明 |
|------|:---:|------|
| api.deepseek.com | X | 国产服务，国内直连 |
| npm 装 Claude Code | X | setup.bat 自动切淘宝镜像 |
| github.com | /!\ | 视网络情况 |

---

### 省钱对比

| | Claude Sonnet (官方) | DeepSeek V4 (本方案) |
|---|---|---|
| 输入 1M tokens | ~$3 | ~$0.27 |
| 输出 1M tokens | ~$15 | ~$1.10 |
| 中等项目 (~500K) | ~$5-8 | ~$0.5-1 |

---

### 前置要求

- Windows 10/11
- Node.js >= 18 ([nodejs.org](https://nodejs.org/))
- DeepSeek API key ([免费注册](https://platform.deepseek.com/))
- Git + GitHub Desktop（可选）
- Python (方案 A 需要，用于 pip install codex-relay)

---

### 这个项目解决什么

中国 Windows 开发者的三个痛点和解决方案：

1. **Codex Desktop 默认走 OpenAI API** — 贵且不便。用 codex-relay 桥接到 DeepSeek，成本降 90%。** — 贵且国内不便。用 codex-relay 桥接到 DeepSeek，成本降 90%。
2. **Claude Code 很强但 API 贵** — 把底座换成 DeepSeek，保留全部工具链。** — 把底座换成 DeepSeek，保留全部工具链。

3. **Codex 终端直接调用 DeepSeek API** — 设置 ANTHROPIC_BASE_URL 环境变量指向 pi.deepseek.com/anthropic，Claude Code 的 API 请求直连 DeepSeek，无需 relay 中间层。

三条路径都在这个仓库里，按需选用。

### 核心原理：Codex 直接调用 DeepSeek API

这是本项目的第三个也是最直接的目的 —— Codex 不经过 relay，直接走 DeepSeek 的 Anthropic 兼容接口：

```
Codex 终端 (本界面)
  │
  │  PowerShell 设置环境变量：
  │  $env:ANTHROPIC_BASE_URL = "https://api.deepseek.com/anthropic"
  │  $env:ANTHROPIC_AUTH_TOKEN = "sk-xxx"
  │
  ▼
claude.cmd -p "你的编程任务"
  │
  │  Claude Code 把环境变量里的 URL 作为 API 后端
  │  所有 /v1/messages 请求发往 api.deepseek.com
  │
  ▼
DeepSeek API (Anthropic 兼容端点)
  │  返回标准 Anthropic 格式响应
  │  (模型实际是 deepseek-v4-pro / v4-flash)
  ▼
Claude Code 解析响应 → 执行工具调用（读文件/写代码/Shell）
  │
  ▼
Codex 审查结果 → git commit → 维护长期上下文
```

**关键点**：`ANTHROPIC_BASE_URL` 是 Claude Code 内置的切换机制。把它指向 DeepSeek 后，Claude Code 的所有 API 调用都直接发到 DeepSeek，不需要 relay 中间层。

实测验证（就在本仓库开发过程中）：

```powershell
# Codex 终端执行
$env:ANTHROPIC_BASE_URL = "https://api.deepseek.com/anthropic"
$env:ANTHROPIC_AUTH_TOKEN = "sk-xxx"
$env:ANTHROPIC_DEFAULT_SONNET_MODEL = "deepseek-v4-pro"
claude -p "给 main.py 加 DELETE /tasks/{task_id} 接口"

# 结果：9.5 秒返回，成功添加接口并通过 git diff 审查
```

---

---

### 文件结构和用途

```
deep-claude-codex/
│
├── setup.bat               一键安装脚本：检测环境 → 切国内镜像 → 
│                           装 Claude Code → 让用户填 key → 生成 deepclaude.bat
│
├── deepclaude.bat          交互式启动（方案 B）：双击打开 CMD，
│                           进入 Claude Code 交互会话，底座 DeepSeek V4
│
├── claude-run.bat          非交互调用（方案 B，Codex 专用）：从 .env 读 key，
│                           执行 claude -p "任务" 后退出，供 AI 助手调度
│
├── .env.example            API key 模板：复制为 .env 填入 DeepSeek key，
│                           不会被 git 提交
│
├── relay/
│   ├── config.toml         Codex Desktop 模型配置：告诉 Codex 走
│   │                       127.0.0.1:4000，模型设为 deepseek-v4-pro
│   │                       复制到 %USERPROFILE%\.codex\config.toml
│   │
│   ├── auth.json           Codex Desktop 认证配置：登录模式 apikey
│   │                       复制到 %USERPROFILE%\.codex\auth.json
│   │
│   └── start-relay.bat     启动 codex-relay（方案 A）：设置上游
│                           api.deepseek.com，监听 4000 端口
│                           必须先启动，再开 Codex Desktop
│
├── docs/
│   └── codex-relay-bridge.md  方案 A 详细文档：架构图、协议转换、
│                              配置详解、启动顺序、开机自启
│
├── README.md               本文件，项目总览
├── .gitignore              忽略 .env 等敏感文件，防止泄露 key
└── LICENSE                 MIT 开源协议
```
---

### FAQ

**Q: 需要 VPN 吗？**
A: 不需要。DeepSeek 国产服务直连，npm 不通自动切国内镜像。

**Q: 方案 A 和 B 选哪个？**
A: 日常对话用方案 A (Codex Desktop + relay)，写代码用方案 B (Claude Code CLI)。两者都用 DeepSeek，底层一样。

**Q: codex-relay 做什么？**
A: 它把 Codex Desktop 发的 OpenAI 格式请求转成 DeepSeek 格式，再把响应转回来。相当于一个本地翻译层。

---

<a name="english"></a>
## English

### Three Approaches

| | Approach A: codex-relay | Approach B: Claude Code CLI |
|---|---|---|
| Method | Local proxy (127.0.0.1:4000) | Environment variables |
| Setup | Start relay  then Codex | Run .bat directly |
| Best for | Codex Desktop native UX | Terminal coding + Git automation |

### Quick Start

\\\at
git clone https://github.com/jeremylpf/deep-claude-codex.git
cd deep-claude-codex
setup.bat
\\\

See [docs/codex-relay-bridge.md](docs/codex-relay-bridge.md) for the relay approach.

### Network

- api.deepseek.com: direct access from China, no VPN needed
- npm: setup.bat auto-switches to npmmirror if unreachable

### Prerequisites

- Windows 10/11
- Node.js >= 18
- DeepSeek API key ([get one](https://platform.deepseek.com/api_keys))
- Python (for Approach A: pip install codex-relay)

### License

MIT  see [LICENSE](./LICENSE)





