# Zikr Vibe 工作日志 — 2026-04-02

## 一、PM 文档（8 份 + 3 份 v2 更新）

### 硬件版（戒指）
| # | 文档 | Notion | 本地 |
|---|------|--------|------|
| 6.4 | GTM Launch Plan | [链接](https://www.notion.so/3353a237d35381d39386d1ed9a4df704) | ~/Desktop/Zikr-Vibe-GTM-Plan.md |
| 6.5 | vs iQibla Battlecard | [链接](https://www.notion.so/3353a237d35381edaef3f56e9108d344) | ~/Desktop/Zikr-Vibe-vs-iQibla-Battlecard.md |
| 6.6 | Growth Loops（硬件版） | [链接](https://www.notion.so/3353a237d35381b5b771c096fc4fe360) | ~/Desktop/Zikr-Vibe-Growth-Loops.md |

**硬件版关键结论**：Lead with STR01 $39（金属+IPX7 vs iQibla 同价塑料）。Mosque Loop（group ranking）是增长引擎。

### 软件版（App）
| # | 文档 | Notion | 本地 |
|---|------|--------|------|
| 7.0 | App PRD v1 | [链接](https://www.notion.so/3353a237d35381729c6acad606b0a4c4) | ~/Desktop/Zikr-Vibe-App-PRD.md |
| 7.0.1 | App PRD v2（调研后更新） | [链接](https://www.notion.so/3363a237d35381c9a5bdfbe5c8b6e35a) | ~/Desktop/Zikr-Vibe-App-PRD-v2.md |
| 7.1 | App Pre-Mortem | [链接](https://www.notion.so/3353a237d353812abf12d51c908eb4bf) | ~/Desktop/Zikr-Vibe-App-PreMortem.md |
| 7.2 | App User Stories | [链接](https://www.notion.so/3353a237d35381b2bd0ac1c51e931b9d) | ~/Desktop/Zikr-Vibe-App-UserStories.md |
| 7.3 | App Tech Architecture | [链接](https://www.notion.so/3353a237d35381109037fc221c3f3efb) | ~/Desktop/Zikr-Vibe-App-TechArchitecture.md |
| 7.4 | App Growth Loops v1 | [链接](https://www.notion.so/3353a237d35381efb113e1f974f808ae) | ~/Desktop/Zikr-Vibe-App-GrowthLoops.md |
| 7.4.1 | App Growth Loops v2（调研后更新） | [链接](https://www.notion.so/3363a237d35381dc82acc4f141bd9d98) | ~/Desktop/Zikr-Vibe-App-GrowthLoops-v2.md |
| 7.5 | User Research: Muslim App Market | [链接](https://www.notion.so/3363a237d35381f48e58cba766745558) | 内容在 PRD v2 和 Growth Loops v2 中 |

---

## 二、战略决策

### 大方向
| 决策 | 内容 |
|------|------|
| **硬件 → 软件 pivot** | 戒指供应商没有 SDK，无法做自有 App 连接戒指。改做纯软件 App，戒指变成可选配件 |
| **从竞争到陪伴** | 调研发现 group ranking 对虔诚穆斯林是 riya'（炫耀/虚伪）。改为 Companion Circle：只看谁今天做了 ✓，不看做了多少 |
| **隐私作为核心卖点** | Muslim Pro 卖数据给美军的丑闻至今未消。"Your dhikr is between you and Allah, not you and a data broker" 是杀手定位 |
| **免费不变** | 穆斯林用户被 Muslim Pro 订阅陷阱吓怕了。免费获客，规模化后做 premium |

### 产品定位
| Before | After |
|--------|-------|
| "Your dhikr. Your hands. Your count." | **"Count your dhikr. Nothing else watches."** |
| Group ranking（竞争） | **Dhikr Circles（陪伴）** |
| Growth by virality (K=2.4) | **Growth by trust (K=0.5, but permanent)** |

### 功能决策
| 决策 | 原因 |
|------|------|
| 排行榜排序：**一致性**（不是总数） | Yun 批准。但 v2 后整个排行榜取消了 |
| 性别分组：**v1.0 跳过** | Yun 批准 |
| App Store 名字：**"Zikr Vibe"**，语言跟系统 | Yun 批准 |
| **33-milestone 强触觉反馈** | 调研发现是所有 dhikr app 评价中 #1 请求功能 |
| **Shared Streak**（共享连续） | Duolingo 数据：有 Friend Streak 的用户完成率高 22%。一人断全组归零，不暴露谁断的 |
| **去掉 Firebase Analytics** | 隐私承诺 — 不追踪任何祈祷数据 |
| **去掉 Firebase Dynamic Links** | 2025.8.25 已废弃，改用 app_links |

---

## 三、调研（两轮）

### 第一轮：需求调研
**来源**：Reddit (r/islam, r/MuslimLounge)、App Store/Play Store 评价、Trustpilot、行业报告

**核心发现**：
1. **Haram 广告** — 几乎所有 1 星差评都是这个。做 dhikr 时弹出赌博/半裸女人广告
2. **Muslim Pro 卖数据给美军** — 永久性信任创伤
3. **iQibla 硬件品质差** — "a well advertised scam selling faulty products"
4. **Group ranking 是 riya'** — 虔诚穆斯林主动回避分享 dhikr 成绩
5. **33-milestone vibration** — #1 最被请求的功能

### 第二轮：竞品好评差评
| App | 评分 | 致命差评 | 我们怎么赢 |
|-----|------|---------|-----------|
| Muslim Pro | 2.9★ Trustpilot | haram 广告 + 卖数据 + 订阅陷阱 | 零广告 + 本地存储 + 免费 |
| iQibla Life | 3.5★ Google Play | BLE 断连 + 电池死丢数据 + 烂 UI | 纯软件不需 BLE + 持久化 |
| Tasbeeh Counter Pro | 4.7★ | 付费后仍有 haram 广告 | 零广告 |
| Pillars | 4.8★ | 崩溃/白屏 | scope 小 = 更稳定 |

### 第三轮：陪伴模式先例
| 偷谁的 | 偷什么 |
|--------|--------|
| Duolingo | Shared Streak（一人断全组断，完成率 +22%） |
| Cohorty | 打勾网格（头像 + ✓，无文字无数字） |
| Nomo | "我还在" 一键 tap |
| BeReal | 纯二元"你今天发了吗"，5300 万下载 |

### 第四轮：技术方案
- Hive → ObjectBox（4 年没更新 vs crash-safe WAL）
- Firebase Dynamic Links → app_links（已废弃）
- wakelock_plus（计数时亮屏）
- adhan_dart（12 种算法离线计算礼拜时间）

---

## 四、代码（Flutter App）

### 项目位置
`~/Desktop/zikr_vibe/`

### 技术栈
Flutter 3.41.6 + Supabase + Hive (本地) + Riverpod (状态) + GoRouter (路由)

### 文件清单

**核心配置**
| 文件 | 功能 |
|------|------|
| `pubspec.yaml` | 依赖清单（去掉了 Firebase Analytics + Dynamic Links，加了 app_links + wakelock_plus） |
| `lib/main.dart` | 入口：Hive 初始化 + Supabase 条件初始化 |
| `lib/app.dart` | MaterialApp.router + theme |
| `lib/core/constants.dart` | Dhikr 类型定义 + Supabase 配置（待填） |
| `lib/core/theme.dart` | 伊斯兰配色系统：先知绿 / 古兰经金 / 大理石白，light + dark mode |
| `lib/core/router.dart` | GoRouter 4 tab + auth guard + Supabase 安全处理 |
| `analysis_options.yaml` | Lint 规则 |

**Dhikr 计数器（核心功能）**
| 文件 | 功能 |
|------|------|
| `lib/features/dhikr/screens/dhikr_screen.dart` | 主页面：全屏 tap + 缩放动画 + 涟漪效果 + 33 进度点 + milestone 金色数字 + 八角星背景 + streak badge + wakelock |
| `lib/features/dhikr/providers/dhikr_provider.dart` | 状态管理：3-5 组独立计数 + 33/66/99/100 milestone 强触觉 + Hive 持久化 + 每组最高 9999 |
| `lib/features/dhikr/models/counter_group.dart` | 数据模型：CounterGroup（id, name, count） |
| `lib/features/dhikr/widgets/counter_display.dart` | 大数字显示组件 |
| `lib/features/dhikr/widgets/progress_ring.dart` | 进度环组件 |
| `lib/features/dhikr/widgets/dhikr_type_selector.dart` | 类型选择器 pills |
| `lib/features/dhikr/widgets/target_selector.dart` | 目标数下拉选择 |

**Streak 追踪**
| 文件 | 功能 |
|------|------|
| `lib/features/streak/screens/streak_screen.dart` | 日历页面：本月+上月网格、翡翠绿标记活跃日、Current/Longest/Lifetime 统计 |
| `lib/features/streak/providers/streak_provider.dart` | Streak 计算：从 Hive 读取活跃日期、倒推连续天数、mercy day 支持 |

**Companion Circles（群组）**
| 文件 | 功能 |
|------|------|
| `lib/features/groups/screens/groups_screen.dart` | 空态 + 隐私承诺 + 创建/加入流程 + Circle card（presence + shared streak） |
| `lib/features/groups/models/circle_model.dart` | Circle 数据模型 + Shared Streak 规则文档 |

**Prayer Times**
| 文件 | 功能 |
|------|------|
| `lib/features/prayer/screens/prayer_screen.dart` | 5 次祈祷时间 + next prayer 绿色高亮 + Qibla Compass 入口（占位数据，待接 adhan_dart） |

**Auth + Profile**
| 文件 | 功能 |
|------|------|
| `lib/features/auth/providers/auth_provider.dart` | Supabase Auth：Apple / Google / Email，nullable 安全处理 |
| `lib/features/auth/screens/login_screen.dart` | 登录页：3 种方式 + email 表单 |
| `lib/features/auth/screens/onboarding_screen.dart` | 3 页引导：Count / Track / Grow |
| `lib/features/profile/screens/profile_screen.dart` | Profile：头像 + 统计 + 设置列表 + 登出（scrollable） |

**导航**
| 文件 | 功能 |
|------|------|
| `lib/shared/widgets/main_shell.dart` | 4 tab 底部导航：Dhikr / Groups / Prayer / Profile |

**数据库**
| 文件 | 功能 |
|------|------|
| `supabase/migrations/001_initial_schema.sql` | 简化版 schema：users + daily_presence（只存 ✓/·）+ streaks + groups（含 shared_streak）+ memberships + invites + notification_prefs + RLS + 触发器 |

### 已验证的功能
- ✅ Dhikr 计数器：tap 计数 + haptic + 进度点 + 组切换
- ✅ 33/66/99/100 milestone 强触觉 + 金色数字
- ✅ 3 组默认 + 可加到 5 组 + 自定义命名
- ✅ 数据持久化（Hive，重启不丢）
- ✅ 进度点（33 颗 tasbih 视觉节奏）
- ✅ 八角星伊斯兰几何背景（极淡 alpha 0.018）
- ✅ 涟漪 + 缩放 tap 动画
- ✅ Streak badge 显示 + 点击进入日历
- ✅ Dhikr Circles 空态 + 隐私提示 + 创建流程
- ✅ Prayer Times 5 次 + next prayer 高亮
- ✅ Profile 统计 + 设置 + 登出
- ✅ 4 tab 导航全部工作
- ✅ Light + Dark mode 自动切换
- ✅ Web build 编译通过
- ✅ Chrome 预览全部截图验证

### 环境搭建
- ✅ Homebrew 安装
- ✅ Flutter 3.41.6 安装
- ✅ CocoaPods 安装
- ✅ Xcode Command Line Tools 配置
- ✅ Web platform 支持
- ✅ iOS/Android/macOS platform 支持

---

## 五、你需要做的

| # | 事项 | 紧急度 |
|---|------|--------|
| 1 | **Supabase 建项目 "zikr-vibe"** → 把 URL 和 anon key 填到 `lib/core/constants.dart` | 高 |
| 2 | **在 Supabase SQL Editor 跑 schema** → `supabase/migrations/001_initial_schema.sql` | 高 |
| 3 | **Google Play Developer 确认** → soulvibeai@gmail.com 能登录 | 中 |
| 4 | 审阅 PRD v2 的 Open Questions（见文档第 11 节） | 低 |

---

## 六、接下来的工作（Week 3-6）

| Week | 内容 |
|------|------|
| 3 | 接 Supabase → Circles 真正能用 + 邀请链接 |
| 4 | 接 adhan_dart 真实礼拜时间 + Qibla compass + 通知 |
| 5 | UI 打磨 + App Store screenshots + listing copy |
| 6 | 测试 + bug fix + 提交 App Store + Play Store |
