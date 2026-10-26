UE 编码规范
1．适用范围与规则来源
[INFERRED][HIGH] 本规范作为 AI-Workflow 插件的 UE 默认编码规范，适用于已确认的 UE 项目及其自有插件中新建、修改的 C++ 代码；非 UE 项目不加载。第三方源码、引擎源码和生成代码不纳入自动格式化范围。
[INFERRED][HIGH] 在上位指令允许范围内，用户明确指令、项目 AGENTS.md 及项目明确指定的编码政策与格式化配置优先于插件默认；未覆盖的规则继续适用。机械排版默认使用本规范同目录的 .clang-format；项目有明确覆盖时使用其实际配置路径，不假定 Docs/PROJECT_POLICY/.clang-format 存在。按同目录 README.md 的路由确认并记录规范来源、覆盖项与本次实际生效配置的绝对路径。可自动执行的排版参数由该配置维护；本规范补充工具无法完整执行的声明间距、人工复核要求，以及命名、依赖、生命周期、线程和验证要求。
[INFERRED][HIGH] API 用法以项目实际使用的引擎版本及源码为准，不直接套用其他版本的接口。
2．排版与格式化
- [INFERRED][HIGH] 使用工程内指定的 clang-format，记录其路径与版本。格式化和检查必须显式使用上述配置，禁止静默采用其他配置或默认风格。
- [INFERRED][HIGH] 新增或修改 C++ 源码后，实际执行格式化，再执行 --dry-run --Werror 检查。仅声明“遵守风格”不算完成。
- [INFERRED][HIGH] 只处理本任务修改的文件。历史代码的整体格式化应单独安排，避免与功能修改混合。
- [INFERRED][HIGH] 格式化在最终构建和验证之前完成；验证窗口内禁止修改源码，包括纯排版修改。
- [INFERRED][HIGH] 配置解析失败、工具缺失或格式化破坏必要头文件顺序时，明确报告。不得擅自调整配置、切换工具或用关闭格式化标记掩盖问题。
- [INFERRED][HIGH] 文件编码及换行遵守仓库 .editorconfig；检查格式化结果没有引入非预期转换。
- [INFERRED][HIGH] 头文件中，类和结构体内相邻的成员变量声明、成员函数声明或定义之间统一空一行；变量与函数相邻时同样执行。每个成员独立声明，不在同一行声明多个成员变量。
- [INFERRED][HIGH] 成员所属的注释、UPROPERTY、UFUNCTION 和其他声明修饰宏与该成员视为一个整体，内部不插入空行；空行位于前一完整成员与下一成员的注释或修饰宏之前。
- [INFERRED][HIGH] clang-format 不能自动为每个成员变量或函数声明添加空行；上述头文件声明间距由编写者维护，并在代码审查时检查。SeparateDefinitionBlocks: Always 只负责定义块间空行，MaxEmptyLinesToKeep: 1 只限制已有连续空行数量，不能替代此项检查。
- [INFERRED][HIGH] if、else、for（含范围 for）、while、do 的语句体统一使用大括号，包括单条语句和空语句体；else if 保留常规链式写法，各条件分支的实际语句体仍使用大括号。由 InsertBraces: true 辅助补齐，RemoveBracesLLVM: false 禁止格式化时移除；宏定义、预处理条件等自动工具未覆盖的位置须人工补齐并复核。
- [INFERRED][HIGH] 函数定义（含头文件内联成员函数）不压缩为单行，定义块之间保留空行；对应配置为 AllowShortFunctionsOnASingleLine: None、AllowShortBlocksOnASingleLine: Never 和 SeparateDefinitionBlocks: Always。
3．命名与可读性
[KNOWN][HIGH] 沿用 UE 命名约定：类型、函数和变量使用 PascalCase；Actor、UObject、普通结构、枚举、接口和模板分别采用适当的 A、U、F、E、I、T 前缀；布尔变量使用 b 前缀。官方编码规范
- [INFERRED][HIGH] 名称表达业务含义，避免没有上下文的 Data、Temp、Manager 以及单字母变量；短小数学循环可以保留惯用局部变量名。
- [INFERRED][HIGH] 时间、距离、大小和频率显式标注单位，例如 DurationSeconds、TimeoutMs、UploadBytes、SimulationHz。
- [INFERRED][HIGH] 区分索引、稳定身份、代数、帧号和序号，不使用同一个整数名称表达不同合同。
- [INFERRED][HIGH] 变量必须逐条声明，适用于全局变量、成员变量和局部变量；每条声明语句只声明一个变量，并独占一行。禁止 int A, B, C; 以及逗号分隔的指针、引用或其他多变量声明；同一声明语句即使拆成多行仍不符合要求。正确写法如下：

```cpp
int A;
int B;
int C;
```

- [INFERRED][HIGH] 一行不堆叠多个独立声明、赋值或副作用。函数保持单一明确职责，不设置机械的行数上限。
- [INFERRED][HIGH] 不为排版或局部命名一致性随意重命名反射类型、序列化字段、公开接口和配置键。
4．头文件与编译依赖
[KNOWN][HIGH] 遵守 IWYU：头文件包含自身需要的声明，.cpp 首先包含对应头文件；不依赖间接 include、PCH 或 Unity Build 偶然提供类型。官方 IWYU 说明
- [INFERRED][HIGH] 头文件使用 #pragma once。反射头文件的 .generated.h 必须保持为最后一个 include。
- [INFERRED][HIGH] 能使用前向声明且不需要完整定义时，优先前向声明；需要完整类型时直接包含实际定义头。
- [INFERRED][HIGH] Build.cs 明确声明直接依赖。公开头暴露的依赖按需要放入 Public，纯实现依赖放入 Private。
- [INFERRED][HIGH] 不通过扩大公共依赖、包含聚合头或恢复 Unity Build 来掩盖缺失依赖。
- [INFERRED][HIGH] 模块迁移后检查导出宏、独立编译和链接；编译通过不等于依赖边界合理。
5．模块与插件边界
- [INFERRED][HIGH] 模块依赖保持单向，禁止循环依赖。纯算法、运行时、网络、表示和渲染职责明确分开。
- [INFERRED][HIGH] 可复用插件不依赖宿主 Demo 或业务模块。宿主通过公开合同提供业务事实与配置。
- [INFERRED][HIGH] Public 仅暴露必要接口和数据；实现细节留在 Private。跨模块接口说明调用线程、所有权和有效期。
- [INFERRED][HIGH] 编辑器 API 与编辑器测试依赖限制在正确的目标或编译条件内，相关 include 同样受保护。
- [INFERRED][HIGH] 客户端专用显示与 Server 隔离。运行时早退不能替代构建依赖检查。
6．UObject、反射与生命周期
[KNOWN][HIGH] 按所有权选择对象引用：受 GC 跟踪的持久属性使用适当的 UPROPERTY 与 TObjectPtr；非拥有缓存使用 TWeakObjectPtr；可延迟加载的资产引用使用 TSoftObjectPtr。裸指针和未标记的 TObjectPtr 不能自行保证 GC 存活。对象指针说明
- [INFERRED][HIGH] 不为了编辑器可见性将所有字段暴露为 Blueprint 可写；属性访问权限与业务用途匹配。
- [INFERRED][HIGH] 组件、委托、定时器和异步任务具有明确的创建者、解绑者及停止顺序。
- [INFERRED][HIGH] 清理操作应支持合理的重复调用。旧实例退出时不能清除新实例拥有的注册、回调或状态。
- [INFERRED][HIGH] 不在每次使用处添加空指针判断来掩盖初始化合同缺失；必须区分可选对象与必须存在的对象。
7．线程与异步任务
- [INFERRED][HIGH] 每个跨线程接口注明生产线程、消费线程、数据所有权和发布边界。
- [INFERRED][HIGH] 涉及后台计算时，后台计算消费拥有的数据快照；涉及组件操作、Niagara API 和要求 GT 的宿主操作时，这些操作在 GT 执行。不涉及这些功能时不凭本条新增后台或 Niagara 依赖。
- [INFERRED][HIGH] 不跨异步边界借用临时数组、Fragment 指针、chunk 范围或可能变化的容器元素地址。
- [INFERRED][HIGH] 任务取消、Stop、World 销毁和重启必须阻止旧结果发布到新会话。
- [INFERRED][HIGH] 并行化前先证明写入范围互不重叠、没有共享写竞争；不以“无锁”或“并行”为设计目标本身。
8．数据与热路径
- [INFERRED][HIGH] 先保证批量处理正确，再依据测量优化。避免逐实体临时分配、重复查询、重复分组和多轮数据复制。
- [INFERRED][HIGH] 使用清晰的 const 与参数传递方式；大型只读数据优先引用，所有权转移明确表达。
- [INFERRED][HIGH] 序列化与协议字段使用明确宽度和范围；不把内存地址、结构体填充或本机布局当作网络合同。
- [INFERRED][HIGH] 容量、时间和计数上限明确；外部输入检查范围、有限数值、身份与版本。
- [INFERRED][HIGH] 诊断、逐实体日志和参考求值不得默默进入正式热路径。优化不能通过关闭业务功能或降低实际处理量隐藏成本。
9．错误处理、断言与日志
- [INFERRED][HIGH] 可恢复输入错误返回明确结果；内部不变量使用适当断言。不得用 check 代替正常的网络、资源或配置错误处理。
- [INFERRED][HIGH] 断言表达式不承载必须执行的副作用，保证不同构建配置的业务行为一致。
- [INFERRED][HIGH] 使用按模块定义的日志类别；错误记录包含必要身份、阶段和失败原因，避免持续重复刷屏。
- [INFERRED][HIGH] 不吞掉错误后静默回退到另一套算法、配置或显示路径。
10．资源、配置与注释
- [INFERRED][HIGH] 通用插件资源使用插件归属路径；具体角色资源通过配置接入，不写死 Demo 资产。
- [INFERRED][HIGH] 配置说明包括默认值、单位、合法范围、生效范围和变更时机。
- [INFERRED][HIGH] 修改反射路径或资产位置时，同时检查引用、重定向、加载及 Cook；不依赖本机缓存验收。
- [INFERRED][HIGH] 注释解释原因、不变量、线程约束和失效条件，不逐句复述代码。
- [INFERRED][HIGH] TODO 写明具体缺口和触发条件，不用泛泛的“以后优化”代替问题记录。
11．验证与交付
- [INFERRED][HIGH] 顺序为：完成修改 → 格式化 → 格式检查 → 差异审查 → 受影响目标构建 → 必要行为验证。
- [INFERRED][HIGH] 根据改变的风险选测试，不为纯排版编写行为测试；新增测试覆盖实际合同，不照抄实现。
- [INFERRED][HIGH] 修改模块、条件编译或资源加载时，验证相应 Editor、Client、Server 或打包目标，不能只验证 Editor。
- [INFERRED][HIGH] 日志、接口调用成功和正常退出不能替代真实画面或联机证据。
- [INFERRED][HIGH] 交付说明实际修改、验证结果和未完成项。严格区分静态检查、构建通过、行为通过、视觉通过和性能达标。
- [INFERRED][HIGH] 本规范不授权批量重排历史代码、修改第三方工程、删除业务功能或扩展任务范围。