# 项目文档入口模板

本文件只用于缺少入口的新项目。已经采用 Git 子模块的项目不应以本模板覆盖现有 Docs/README.md。

## 当前入口

1. 读取项目根 AGENTS.md 和项目政策。
2. 读取 Docs/AI-Workflow/AI_WORKFLOW/00_工作流入口.md，按当前任务类型选择流程。
3. 按项目根入口定位当前状态，默认使用 Docs/PROJECT_STATE，不将此模板当作运行事实。
4. 同线程压缩恢复使用 Docs/AI-Workflow/AI_ENTRY/01_压缩恢复.md，不默认全文重读全部工作流。
5. 变更前确认真实源码或文档入口、范围和影响；已有明确授权按工作流入口持续执行，不重复确认。

## 文件职责

- Docs/README.md：项目引导入口。
- Docs/AI-Workflow/AI_ENTRY：会话状态入口，不保存当前项目事实。
- Docs/AI-Workflow/AI_WORKFLOW：共享实施方法，不保存项目待办、机器路径或具体业务流程。
- Docs/PROJECT_POLICY：项目长期政策。
- Docs/PROJECT_STATE：当前方案、交接、待办、合同、状态及证据索引。

## 开发与验证

默认按完整功能边界组织方案和主体实施，随后集中验证和修复；基础检查支持持续开发。
UE 独立测试优先使用 UE LLT，不默认自写裸 main()、手工断言与编译脚本。
具体要求见 Docs/AI-Workflow/AI_WORKFLOW/01_开发修改与维护规范.md 和 Docs/AI-Workflow/AI_WORKFLOW/04_功能验证与构建.md。

文本默认使用 UTF-8。项目有不同状态路径时使用实际配置，不凭模板假定缺少文件或创建另一套状态。
