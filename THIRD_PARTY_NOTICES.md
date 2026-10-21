# 第三方来源与许可证核查

核查范围为原始提交 `d5d19750f362dd5f7eb48ef47e431bdf5e6b0cf4` 及本次整理新增依赖。区分“本地文件有直接标注”“已核对上游声明”和“仅有来源线索”，避免把可见源码误当成已获开源授权。

## 仓库内附带的组件

| 组件与路径 | 来源证据 | 许可状态 / 已采取措施 |
|---|---|---|
| JsonCpp：`src/bobac3_audio/src/jsoncpp/`、`include/robot_audio/json/` | 文件版权标注 Baptiste Lepilleur，`json/version.h` 声明 0.7.0；[上游](https://github.com/open-source-parsers/jsoncpp/tree/0.7.0) | 本地标注 MIT / Public Domain；已补回 [上游 0.7.0 LICENSE](LICENSES/JsonCpp-0.7.0.txt)。未声称所有本地文件与该标签逐字一致 |
| AIUI SDK：`include/robot_audio/aiui/`、`libs/libaiui.so`、`libmsc.so`、`libvtn_mic1.so`、`AIUI/` 资源 | AIUI 头文件直接标注 [讯飞 AIUI 平台](https://aiui.xfyun.cn/)；3 个库已检查为 x86-64 ELF | 仓库没有 SDK 许可/EULA，版本及再分发范围待确认；保留运行资源，不套用 JsonCpp 或 ROS 的许可证 |
| `bobac3_*`、`oryxbot_*` 及 `reinovo_voice` 封装 | 维护者字段 `reinovo`/`cute`、厂商命名；[reinovo 项目列表](https://gitee.com/reinovo) 与 [oryxbot_ws](https://gitee.com/reinovo/oryxbot_ws) 为来源线索 | 本地许可证为 TODO；未锁定确切上游提交，也未取得分发授权。所核查的 oryxbot_ws 页面同样未声明许可证 |
| `src/bobac3_audio/src/zbase64/` | 本地文件未发现作者/许可标注 | 来源与授权均待确认；未猜测或补写作者 |
| 地图、bag、音频与模型线索 | 原始仓库已有资源；模型包未包含 | 数据采集者、资源来源及公开分发范围缺少独立清单，不从代码许可推导数据许可 |

三份 SDK 运行库不是本工程编译输出，因此没有随 `build/`、`devel/` 一起删除。可定位的二进制哈希和包许可缺口见 [third_party_manifest.json](benchmarks/results/third_party_manifest.json)。

## 作为外部依赖使用的上游软件

以下核对的是上游 `package.xml` 的声明，不是本仓库的统一许可证；依赖的间接组件仍各自保留许可。

| 外部依赖 | 核对的声明 | 上游来源 |
|---|---|---|
| `teb_local_planner` | BSD；其优化依赖还涉及 g2o 等组件 | [rst-tu-dortmund/teb_local_planner](https://github.com/rst-tu-dortmund/teb_local_planner/tree/noetic-devel) |
| `move_base` | BSD | [ros-planning/navigation](https://github.com/ros-planning/navigation/blob/noetic-devel/move_base/package.xml) |
| `amcl` | LGPL | [上游包声明](https://github.com/ros-planning/navigation/blob/noetic-devel/amcl/package.xml) |
| `map_server` | BSD | [上游包声明](https://github.com/ros-planning/navigation/blob/noetic-devel/map_server/package.xml) |
| `navfn` | BSD | [上游包声明](https://github.com/ros-planning/navigation/blob/noetic-devel/navfn/package.xml) |
| 离线分析依赖 | 按各发行版附带许可使用；没有把依赖源码复制进本仓库 | [rosbags](https://gitlab.com/ternaris/rosbags)、[Matplotlib](https://matplotlib.org/)、[PyYAML](https://pyyaml.org/)；版本见 `requirements-audit.txt` |

## 仍需补齐的具体材料

1. 原始厂商源码/模型包的下载来源、版本或提交，以及随附许可证/授权文件。
2. 当前 AIUI SDK 版本对应的许可/EULA，及库、模型资源的分发范围。
3. `zbase64` 的确切来源与许可；地图、音频和录制数据的来源说明。
4. 维护者确认的原创文件范围，然后对有权授权的内容选择许可证并更新相应包清单。

这些未决项已公开标记，不能通过把 `TODO` 批量替换成 `MIT` 来“修复”。
