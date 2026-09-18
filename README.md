# 四象限优先级（InternToolkit 桌面独立版）

一个**纯本地、零联网**的桌面效率工具，核心是「艾森豪威尔四象限」优先级排序，并附带实习生能力指南页。所有数据只存在你自己的电脑里，不上传、不联网、无账号。

> 作者：Lin Long ｜ 许可证：MIT

---

## ✨ 功能特性

- 📋 **四象限优先级排序** —— 拖拽任务到「重要/紧急」四个象限，快速厘清轻重缓急
- ✅ **任务管理** —— 添加、拖拽排序、完成勾选
- 💾 **本地持久化** —— 数据保存在浏览器 `localStorage` + 本地文件 `data/storage.json`
- 📤 **导入 / 导出** —— 支持 JSON / CSV 导出，方便备份与换机迁移
- 📖 **实习生能力指南** —— 附带 `index.html` 指南页
- 🌐 **完全离线可用** —— 不连接任何远程服务器，无统计埋点，无外部 API 调用
- 🔒 **仅本机访问** —— 本地服务只绑定 `127.0.0.1`，局域网与互联网均无法访问

---

## 🚀 快速开始

1. 将本仓库克隆 / 下载并解压到任意文件夹
2. 双击 `启动.bat`（首次运行 = 自动安装 + 打开页面）
3. 之后可双击桌面快捷方式「InternToolkit」，或依赖开机自启

```bat
git clone https://github.com/lin-001-007/-.git
cd -
启动.bat
```

> 首次运行会自动注册 Windows 计划任务实现开机自启，并创建桌面快捷方式。

---

## 📁 项目结构

```
四象限优先级/
├── 启动.bat              # 唯一入口，首次运行 = 安装 + 打开
├── 恢复旧数据.bat        # 换打开方式后找回旧数据的辅助入口
├── priority.html        # 优先级排序（艾森豪威尔四象限）主页面
├── index.html          # 实习生能力指南页
├── config.ini          # 可选配置（一般无需修改）
├── 使用说明.txt         # 详细使用说明
├── README.md          # 本文件
├── data/              # 数据目录（运行时生成 storage.json）
│   └── 说明.txt
└── scripts/           # 内部脚本，无需手动打开
    ├── boot-open.bat
    ├── launch.ps1
    ├── serve.ps1
    ├── ensure-server.ps1
    ├── create-shortcut.ps1
    ├── install-daily-browser.ps1
    ├── uninstall-daily-browser.ps1
    └── write-installed.ps1
```

---

## ⚙️ 配置说明

`config.ini` 可选项：

```ini
# OPEN_GUIDE=1 时，开机自启会同时打开 index.html 指南页
OPEN_GUIDE=0
```

---

## 🔒 隐私与数据

- 所有任务与操作记录**仅存在本机**两处：
  - 浏览器 `localStorage`（按访问地址区分）
  - `data/storage.json`（通过 `启动.bat` 打开时自动同步）
- 本工具**不含广告、不含统计埋点、不含外部 API 调用**
- 本地服务仅监听 `127.0.0.1:17890`，**不对外网开放端口**
- 无注册、无登录、无云备份

> 仓库已通过 `.gitignore` 忽略 `.installed.json`、`data/storage.json`、`.server.pid` 等含本机信息或使用记录的运行时文件，请放心使用。

---

## 🛠️ 系统要求

- Windows 10 / 11
- 任意现代浏览器（Edge、Chrome 等）
- 无需安装 Node、Python 或其他软件

---

## ❓ 常见问题

**Q：必须联网吗？**
A：不需要，完全离线可用。

**Q：历史记录突然全空了？**
A：多半是换了打开方式（未用 `启动.bat`）或浏览器清过数据。先运行 `恢复旧数据.bat` 尝试找回。

**Q：数据会上传到网上吗？**
A：不会，所有数据仅在本机浏览器本地存储。

**Q：别人能通过网络看到我的任务吗？**
A：不能，服务仅绑定本机 `127.0.0.1`。

**Q：如何取消开机自启？**
A：在 Windows「任务计划程序」中删除 `InternToolkit-DailyBrowser`，或运行 `scripts/uninstall-daily-browser.ps1`。

---

## 📦 数据备份建议

- 建议每周在 priority 页面底部导出一次「分析包」
- 换电脑：旧电脑导出 → 新电脑解压安装 → 导入 JSON
- 重装系统前务必先导出备份

---

## 📄 许可证

[MIT License](LICENSE)
