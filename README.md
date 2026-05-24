# deep-claude-codex

> Windows 一键搭建：Codex Desktop + Claude Code + DeepSeek，中国用户的开源 AI 编程方案。

[中文](#chinese) | [English](#english)

---

<a name="chinese"></a>
## 中文

### 两套方案

本项目提供两种方式在 Windows 上使用 DeepSeek 驱动 AI 编程：

`
方案 A: Codex Desktop  codex-relay  DeepSeek (推荐日常使用)
方案 B: Codex 终端  Claude Code CLI  DeepSeek (编程/自动化)
`

| | 方案 A: codex-relay | 方案 B: Claude Code CLI |
|---|---|---|
| 桥接方式 | 本地代理 (127.0.0.1:4000) | 环境变量 |
| 启动要求 | 先启 relay  再开 Codex | 直接运行 bat |
| 适用场景 | Codex Desktop 原生体验 | 终端编程 + Git 自动化 |
| 协议转换 | relay 自动转换 DeepSeek  OpenAI | Anthropic 兼容接口直连 |

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

### 项目结构

\\\
deep-claude-codex/
  setup.bat             一键安装脚本
  deepclaude.bat        交互式启动 (方案B)
  claude-run.bat        非交互脚本 (方案B, Codex调用)
  .env.example          API key 配置模板
  relay/
    config.toml         Codex Desktop 配置 (方案A)
    auth.json           认证配置 (方案A)
    start-relay.bat     启动 relay (方案A)
  docs/
    codex-relay-bridge.md  方案A 详细文档
  README.md
  .gitignore
  LICENSE (MIT)
\\\

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

### Two Approaches

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
