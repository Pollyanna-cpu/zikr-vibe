# Zikr Vibe — Claude Code 项目说明

这个 repo 是 Pollyanna Universe 的子项目。本文件被任意 Claude / Codex session 进入 repo 时自动加载，作为项目级 memory。

## 红线: push 完必写 Notion Run

每次 `git push`（无论代码量大小、无论 branch、无论是否 merge），必须在 Notion Cockpit
**`Runs · 任务/调度`** 数据库写一条 Run page。

- **Data source ID**: `34b3a237-d353-8006-9ff6-000b438d9cb7`
- **父页**: `CC与Codex的YUN` (https://www.notion.so/34b3a237d353801f8f98c94e8bac5a52)

写 Run 用 Notion MCP `notion-create-pages`，`parent.data_source_id` 填上面那个 ID。

## 必填字段

| 字段 | 说明 |
|---|---|
| `Title` | 简短任务名 |
| `Brief` | 一句话 + 关键改动列表 |
| `Executor` | `CC-CEO` / `Claude-Worker` / `Codex-MacPro` / `Codex-MacAir` / `Yun` |
| `Mode` | `audit` / `plan` / `change` |
| `Status` | `done`（push 完成时）；进行中可用 `in_progress` / `waiting_review` |
| `Push-Deploy Permission` | `yes` / `no` / `pending` |
| `Output` | commit URL: `https://github.com/Pollyanna-cpu/zikr-vibe/commit/<hash>`（或 PR URL） |
| `date:Started At:start` + `date:Finished At:start` | ISO 日期 (e.g. `2026-05-15`) |

## 失败历史 (don't be next)

漏写已 5 次复现，每次都要后续 audit + 手工回填：

| 日期 | 漏写规模 |
|---|---|
| 5/2 | /privacy commit (`498e33f`) |
| 5/3 | 4 commits (NBidea IndexNow / llms.txt / LIBRARY_SHELF / TOM v5) |
| 5/10 | v1.0.12 release (`49f90ba`, 26 file +857-325) |
| 5/13 | 4 deliverable (Pitch Book / Marketing / 专利 / v1.0.12 P3) |
| 5/15 | 2 个独立 audit 撞车回填 (web Claude + 桌面 CC) |

## Hook setup (一次性, 每个 dev 环境)

```bash
git config core.hooksPath .githooks
```

启用后每次 `git push` 会打印 reminder（不阻断，纯提醒）。若未来 14 天仍复现漏写，会升级为硬阻断（`Run-URL:` trailer 检查）。

## 其他约定

- 不要 commit `.claude/`（已在 `.gitignore`）
- App 是 Flutter，web build deploy via `.github/workflows/deploy-web.yml`（push to `main` → GH Pages）
- Apple Sign In 按钮 (`lib/features/auth/screens/login_screen.dart`) 在 PR #1 (draft)，等付费用户够买 Apple Dev 后 merge — 别擅自 enable / 别再加 button
- Supabase project: `ocxnevqgjiyhwdfpskfc` (zikrvibe / main PRODUCTION)
- 命名约定: branch `claude/<task>-<HAHk8-style-suffix>`
