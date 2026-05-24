# deep-claude-codex

> Windows 一键搭建：Claude Code + DeepSeek + Codex，面向中国用户的开源整合方案。

[English](#english) | [中文](#chinese)

---

<a name="chinese"></a>
## 🇨🇳 中文

### 这是什么？

`deep-claude-codex` 让你在 Windows 上一键拥有 AI 编程三件套：

```
┌──────────────────────────────────────────┐
│            deep-claude-codex             │
│                                          │
│  Claude Code CLI ──  AI 编程代理层       │
│       │ (文件读写 / Shell / Git / 子代理) │
│       ▼                                  │
│  DeepSeek V4 ──────── 模型推理层          │
│       │ (deepseek-v4-pro / v4-flash)     │
│       ▼                                  │
│  你的代码仓库 ──────── 实际干活的地方       │
└──────────────────────────────────────────┘
```

**核心思路**：Claude Code 是公认最好的 AI 编程 CLI 工具，但 Anthropic API 对国内用户太贵。DeepSeek 提供了 Anthropic 兼容接口，我们把 Claude Code 的底座换成 DeepSeek，用十分之一的价格享受同样的编码体验。

### 两个目的

| # | 目的 | 说明 |
|---|------|------|
| 1 | **省钱** | DeepSeek API 价格约为 Claude 的 1/10，token 成本大幅降低 |
| 2 | **复用 Claude Code 工具链** | Claude Code 的文件编辑、Shell、Git、子代理等全部保留，只是推理模型换成 DeepSeek |

### 三步安装

```bat
:: 1. 克隆仓库
git clone https://github.com/YOUR_USERNAME/deep-claude-codex.git
cd deep-claude-codex

:: 2. 运行一键安装
setup.bat

:: 3. 启动
deepclaude.bat
```

`setup.bat` 会自动：
1. 检测 Node.js 环境
2. 网络不通自动切淘宝 npm 镜像
3. 安装 Claude Code CLI
4. 让你输入 DeepSeek API key → 自动生成 `deepclaude.bat`

> **获取 DeepSeek API key**：[platform.deepseek.com/api_keys](https://platform.deepseek.com/api_keys)

### 两种使用方式

#### 方式一：独立窗口（推荐新手）

双击 `deepclaude.bat`，弹出 CMD 窗口，直接和 Claude Code 对话编程。

#### 方式二：通过 Codex 调用（推荐进阶）

在 Codex 终端里，AI 助手直接帮你调 Claude Code：

```
你说：「给 main.py 加个搜索接口」
      ↓
Codex 自动调用：claude -p "给 main.py 加搜索接口"
      ↓
Codex 审查结果 → git commit
      ↓
下次继续，上下文不丢
```

### 网络说明

- **DeepSeek API (`api.deepseek.com`)**：国产服务，国内直连，**不需要 VPN**
- **npm 安装 Claude Code**：如果卡住，`setup.bat` 会自动切换到淘宝镜像 (`registry.npmmirror.com`)
- **全程零 VPN** 可用

### 省钱对比

| | Claude Sonnet (官方) | DeepSeek V4 (本方案) |
|---|---|---|
| 输入 1M tokens | ~$3 | ~$0.27 |
| 输出 1M tokens | ~$15 | ~$1.10 |
| 一个中等项目 (约 500K tokens) | ~$5-8 | ~$0.5-1 |

> 价格参考 2025 年公开定价，实际以官网为准。

### 前置要求

- Windows 10/11
- Node.js >= 18（[nodejs.org](https://nodejs.org/)）
- DeepSeek API key（[免费注册](https://platform.deepseek.com/)）
- Git（可选，用于版本管理）
- GitHub Desktop（可选，可视化 Git）

### FAQ

**Q: 需要 VPN 吗？**
A: 不需要。DeepSeek 是国产服务，`setup.bat` 遇到 npm 不通会自动切国内镜像。

**Q: 和直接用 Claude Code 有什么区别？**
A: 界面、工具、操作方式完全一样。唯一的区别是背后的模型从 Claude 换成了 DeepSeek，价格降 90%。

**Q: 支持哪些 DeepSeek 模型？**
A: 默认主模型 `deepseek-v4-pro`，子代理用 `deepseek-v4-flash`。可以改 `deepclaude.bat` 切换。

**Q: Codex 是什么？**
A: Codex 是 OpenAI 的桌面 AI 编程助手，可以在终端里持续管理项目上下文、自动调 Claude Code 写代码、做 Git 管理。

**Q: deepclaude.bat 开机自启后如何使用？**
A: 不需要自启。需要编程时双击打开，Codex 方案则是随时在 Codex 界面里调用。

### 项目结构

```
deep-claude-codex/
├── setup.bat          # 一键安装脚本
├── deepclaude.bat     # 启动脚本 (由 setup.bat 生成, 含你的 key)
├── README.md          # 本文件
├── .gitignore         # 忽略敏感文件
└── LICENSE            # MIT
```

---

<a name="english"></a>
## 🇬🇧 English

### What is this?

`deep-claude-codex` provides a one-click setup for AI-powered coding on Windows, combining Claude Code's toolchain with DeepSeek's affordable models — designed for developers in China and beyond.

### Architecture

```
Claude Code CLI (agent/tool layer)
    ↓ Anthropic-compatible API
DeepSeek V4 (model/inference layer)
    ↓
Your code repository
```

### Why?

Claude Code is arguably the best AI coding CLI, but Anthropic API costs add up fast. DeepSeek offers an Anthropic-compatible endpoint at ~1/10 the price. This project bridges the two so you keep the full Claude Code experience with DeepSeek economics.

### Quick Start

```bat
git clone https://github.com/YOUR_USERNAME/deep-claude-codex.git
cd deep-claude-codex
setup.bat
deepclaude.bat
```

### Two Usage Modes

1. **Standalone**: Double-click `deepclaude.bat` → interactive Claude Code session
2. **Via Codex**: Your Codex AI assistant calls `claude -p "task"` on demand, maintaining long-term project context across sessions

### Network

- `api.deepseek.com` is accessible directly from China — **no VPN needed**
- `setup.bat` auto-switches to npmmirror if npm registry is unreachable

### Prerequisites

- Windows 10/11
- Node.js >= 18
- DeepSeek API key ([get one](https://platform.deepseek.com/api_keys))
- Git (optional)
- GitHub Desktop (optional)

### License

MIT — see [LICENSE](./LICENSE)
