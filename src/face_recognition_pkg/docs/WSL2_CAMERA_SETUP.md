# WSL2 摄像头配置指南

WSL2 默认不支持直接访问 USB 摄像头。需要通过 `usbipd-win` 将 USB 设备从 Windows 传递到 WSL2，并且可能需要编译支持摄像头的 WSL2 内核。

## 方案一：使用 usbipd-win（推荐先尝试）

### 步骤 1：检查 Windows 版本

确保您运行的是 Windows 11 (Build 22000+) 或 Windows 10 (通过 Microsoft Store 更新 WSL)。

在 Windows 中按 `Win + R`，输入 `winver` 查看版本。

### 步骤 2：更新 WSL 内核

在 **Windows PowerShell (管理员)** 中执行：

```powershell
# 关闭所有 WSL 实例
wsl --shutdown

# 更新 WSL 到最新版本
wsl --update

# 查看内核版本
wsl --version
```

### 步骤 3：在 Windows 安装 usbipd-win

**方法一：使用 winget（推荐）**

在 **Windows PowerShell (管理员)** 中执行：

```powershell
winget install --interactive --exact dorssel.usbipd-win
```

**方法二：手动安装**

1. 访问 https://github.com/dorssel/usbipd-win/releases
2. 下载最新的 `.msi` 安装文件
3. 运行安装程序

### 步骤 4：在 WSL2 中安装 USB/IP 工具

在 WSL2 终端中执行：

```bash
sudo apt update
sudo apt install linux-tools-generic hwdata
sudo update-alternatives --install /usr/local/bin/usbip usbip /usr/lib/linux-tools/*-generic/usbip 20
```

### 步骤 5：连接摄像头到 WSL2

1. **列出 USB 设备**（Windows PowerShell 管理员）：

```powershell
usbipd list
```

输出示例：
```
Connected:
BUSID  VID:PID    DEVICE                                       STATE
1-2    0c45:6723  Integrated Webcam                           Not shared
2-1    8087:0029  Intel Bluetooth                             Not shared
```

2. **绑定摄像头设备**（需要管理员权限，只需执行一次）：

```powershell
usbipd bind --busid <BUSID>
# 例如: usbipd bind --busid 1-2
```

3. **附加设备到 WSL2**：

```powershell
# 确保 WSL2 正在运行
wsl

# 在另一个 PowerShell 窗口中执行
usbipd attach --wsl --busid <BUSID>
# 例如: usbipd attach --wsl --busid 1-2
```

4. **在 WSL2 中验证**：

```bash
# 检查 USB 设备
lsusb

# 检查视频设备
ls /dev/video*
```

### 步骤 6：断开设备

```powershell
usbipd detach --busid <BUSID>
```

---

## 方案二：编译支持摄像头的 WSL2 内核

如果方案一中摄像头显示在 `lsusb` 但 `/dev/video*` 不存在，需要编译自定义内核。

### 使用预编译内核（简单方法）

参考项目：https://github.com/PINTO0309/wsl2_linux_kernel_usbcam_enable_conf

```bash
# 克隆仓库
git clone https://github.com/PINTO0309/wsl2_linux_kernel_usbcam_enable_conf.git
cd wsl2_linux_kernel_usbcam_enable_conf

# 查看可用版本
ls *.tar.gz

# 解压对应版本的内核
tar -zxvf 5.15.90.1.tar.gz

# 将内核复制到 Windows
cp vmlinux /mnt/c/Users/<你的Windows用户名>/
```

### 配置 WSL 使用自定义内核

在 Windows 中创建或编辑 `C:\Users\<用户名>\.wslconfig`：

```ini
[wsl2]
kernel=C:\\Users\\<你的Windows用户名>\\vmlinux
```

然后重启 WSL：

```powershell
wsl --shutdown
wsl
```

### 手动编译内核（高级方法）

```bash
# 1. 安装依赖
sudo apt update && sudo apt upgrade
sudo apt install build-essential flex bison dwarves libssl-dev libelf-dev cpio libncurses-dev bc

# 2. 下载 WSL2 内核源码
cd ~
git clone --depth 1 https://github.com/microsoft/WSL2-Linux-Kernel.git
cd WSL2-Linux-Kernel

# 3. 配置内核
make menuconfig KCONFIG_CONFIG=Microsoft/config-wsl
```

在配置菜单中启用以下选项：

- `Device Drivers` → `Multimedia support` → 改为 `[*]`
  - `Filter media drivers` → `[*]`
  - `Media device types` → `Cameras and video grabbers` → `[*]`
  - `Media drivers` → `Media USB Adapters` → `[*]`
    - `USB Video Class (UVC)` → `[M]`
- `Device Drivers` → `USB support` → `[*]`
  - `Support for Host-side USB` → `[*]`
  - `USB/IP support` → `[*]` (及其所有子项)

```bash
# 4. 编译内核 (需要较长时间)
make -j$(nproc) KCONFIG_CONFIG=Microsoft/config-wsl

# 5. 复制内核到 Windows
cp arch/x86/boot/bzImage /mnt/c/Users/<用户名>/vmlinux
```

配置 `.wslconfig` 后重启 WSL。

---

## 验证摄像头工作

```bash
# 检查视频设备
ls -la /dev/video*

# 安装 v4l2 工具
sudo apt install v4l-utils

# 查看摄像头信息
v4l2-ctl --list-devices
v4l2-ctl -d /dev/video0 --all

# 测试 OpenCV 访问
python3 -c "import cv2; cap = cv2.VideoCapture(0); print('摄像头打开成功' if cap.isOpened() else '摄像头打开失败')"
```

---

## 快速启动脚本

创建 Windows 批处理文件 `start_camera_wsl.bat`：

```batch
@echo off
echo 正在将摄像头连接到 WSL2...
usbipd attach --wsl --busid 1-2
echo 完成！
pause
```

---

## 常见问题

### Q: usbipd list 没有显示摄像头？
A: 检查摄像头是否被 Windows 其他程序占用，关闭所有使用摄像头的应用。

### Q: 摄像头在 lsusb 显示但 /dev/video* 不存在？
A: 需要编译支持 UVC 的 WSL2 内核（见方案二）。

### Q: 权限问题？
A: 将用户添加到 video 组：
```bash
sudo usermod -aG video $USER
# 重新登录 WSL
```

### Q: 每次重启都要重新 attach？
A: 是的，`usbipd attach` 需要在每次 WSL 重启后重新执行。可以创建脚本自动化。

---

## 替代方案：图片文件测试

如果摄像头配置困难，可以先使用图片文件测试人脸识别功能：

```bash
# 运行人脸识别节点后，输入图片路径进行测试
roslaunch face_recognition_pkg face_recognition.launch

# 在交互界面输入: test /path/to/image.jpg
```
