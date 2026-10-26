# 项目开发工作流

中文技能插件与共享规则仓库。先厘清方案，连续完成主体框架和生产接入，再集中验证、归并修复与验收。
UE 独立测试优先 LLT，不默认建立裸 main()、手工断言和编译脚本组成的另一套测试入口。

## 从 GitHub 添加插件市场

本仓库同时提供市场索引与插件本体：

- .agents/plugins/marketplace.json：市场 dunching-ai-workflow，显示名称“AI 开发工作流”。
- plugin.json：插件 ai-workflow。
- skills/project-ai-workflow/SKILL.md：保留兼容的开发工作流入口。
- skills/wf-start、wf-resume、wf-status、wf-check：四个轻量会话入口，规则仍引用 AI_ENTRY 与 AI_WORKFLOW。
- AI_WORKFLOW 与 AI_ENTRY：随包规则和会话入口，只有一份正文。

在 Codex“添加插件市场”中填写：

- 来源：https://github.com/dunching/AI-Workflow.git
- Git 引用：main
- 稀疏路径：留空；市场索引和插件都位于本仓库，不能只取不存在的 plugins/codex。

也可按本机 CLI 支持的方式添加：

```text
codex plugin marketplace add https://github.com/dunching/AI-Workflow.git --ref main
```

添加市场后，在该市场安装“项目开发工作流”，再于任务中加载插件。
这套插件只提供技能与参考文件，不需要服务器、密钥或 MCP 工具。

## 不保留项目副本时

项目仍保留根 AGENTS.md、项目政策、状态、合同和实际源码；通用规则由已加载插件提供。
用稳定的技能名发出指令，不写开发机盘符或某个缓存版本路径：

| 短技能 | 实际意图 | 兼容调用 |
| --- | --- | --- |
| $wf-start | 新会话初始化/首次接手项目 | $project-ai-workflow 执行新会话 |
| $wf-resume | 实际压缩后恢复/明确要求压缩恢复 | $project-ai-workflow 执行压缩恢复 |
| $wf-status | 状态恢复/重新对齐项目事实 | $project-ai-workflow 执行状态恢复 |
| $wf-check | 修改前核对事实、范围和授权 | $project-ai-workflow 执行修改前确认 |

自然语言仅在真实意图匹配时用于隐式选择，引用、讨论或修改这些短语不触发执行；不保证宿主每次自动命中，也不注册自定义斜杠命令或 GUI 新会话事件。
新会话完整读取插件 AI_WORKFLOW 当前规则后读项目当前政策与状态；压缩恢复按摘要、最新意图、强制约束和相关变化轻量核对，不重读全部历史。
所有项目相关回复持续采用“项目状态”一句话及“1. 固定回复内容 / 2. 实际回复”，具体规则只维护在[工作流入口](AI_WORKFLOW/00_工作流入口.md)。

技能从自身文件位置解析随包入口；项目 Git 和状态读取始终发生在当前项目。
收到压缩提示后按项目入口指令执行恢复；插件不会自行安装压缩事件回调或后台脚本。
技能未加载时会明确报告，不自动重新克隆已移除的 Docs/AI-Workflow。

可复制的项目入口文字见 [项目入口迁移模板](PROJECT_README.md)。
移除项目内目录之前，先替换旧入口及自动初始化要求；子模块清理由用户另行授权。

## 开发与维护

- 方案说明目标、调用链、所有权、版本、范围、交付批次与验收条件。
- 完整功能边界持续实施，实现期间做基础检查，主体接通后集中验收。
- 同因失败归并修复，超预算或主体停滞时复盘；按实际交付汇报。
- 当前状态简明，已有授权及有效证据复用，不强制逐条测试驱动、提交或反复审批。

新会话完成完整规则基线后，日常任务从[工作流入口](AI_WORKFLOW/00_工作流入口.md)按需读取，当前项目事实不保存在插件里。
插件版本是发布快照；仓库推送、市场刷新、插件安装更新和账号私有插件发布分别报告。
Scripts/Sync-AIWorkflowToProject.ps1 只供历史复制方式兼容，不作为插件安装命令，也不在插件模式自动执行。

