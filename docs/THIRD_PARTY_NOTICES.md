# 第三方代码、资源与许可证核查

本页是仓库级初步审计记录，不构成法律意见。**目前没有根目录 LICENSE，不能据此认定整仓库可以按某个开源许可证重新分发。** 多个 ROS 包的 package.xml 仍使用 license TODO。

| 组件/路径 | 已观察到的来源线索 | 许可证/分发状态 | 后续动作 |
|---|---|---|---|
| AIUI SDK 头文件与资源：src/bobac3_audio/include/robot_audio/aiui/、src/bobac3_audio/libs/、AIUI/、AIUI_backup/ | AIUI.h 头部标注“AIUI开放平台”并链接 https://aiui.xfyun.cn/；仓库含 libaiui.so、libvtn_mic1.so 和 SDK 资源 | 本仓库未包含可确认的 SDK 许可文本、版本号或可再分发条款；状态未解决 | 从官方 SDK 下载包或合同中确认版本、许可与再分发权限；确认前不要承诺可自由复制这些二进制/资源 |
| JSONCpp：src/bobac3_audio/src/jsoncpp/，以及相关头文件 | json/json.h 标注 Copyright 2007–2010 Baptiste Lepilleur，并指向 JSONCpp 的 MIT/public-domain 说明 | 源码头部包含许可线索，但其引用的 LICENSE 文件未随本仓库找到 | 保留原始版权头；从对应上游版本补齐许可文本，或改用系统依赖并记录版本 |
| src/bobac3_description | Git 树中是 gitlink；仓库没有 .gitmodules，GitHub API 未返回可用子模块 URL | 来源和许可证无法从当前仓库确定 | 从原工作区/维护者恢复 URL、固定 commit 和许可证；恢复前不猜测来源 |
| 地图、模型、bag、音频资源 | 包含多张 .pgm 地图、.bag 录制数据及 .wav 音频 | 资源作者、采集授权和再分发条件未逐项确认 | 标记自采/第三方来源，确认是否含个人或场地敏感信息；未确认前不要把它们当作无条件可再分发素材 |
| ROS 包及项目源码 | 多个 package.xml 使用占位许可证 TODO | 项目自身授权未明确 | 由版权持有人选择并确认项目许可证，再逐个修正 manifest；不能替作者擅自选择许可证 |

## 仓库清理策略

- build/、devel/ 是 Catkin 生成产物，已从清理分支中移除，并通过 .gitignore 防止再次加入。它们还包含旧机器绝对路径和生成文件，不适合作为源码分发内容。
- AIUI/msc/*.log 是运行日志，已从清理分支移除；日志不应作为 SDK 源码分发。
- AIUI_backup/ 与其他 AIUI 目录存在重复资源，但其中的音频/配置并非完全一致。本次不删除整个备份目录，避免误删运行必需资源；需在确认实际启动路径后再决定是否归档或移除。
- 两个 .bag 文件和地图图像暂时保留，因为它们可能是实验数据或导航地图；清理前应先检查内容与引用关系。
