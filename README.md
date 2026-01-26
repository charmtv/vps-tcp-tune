<div align="center">

# 🚀 BBR v3 优化脚本 - Ultimate Edition

**XanMod 内核 + BBR v3 + 全方位 VPS 管理工具集**

[![GitHub stars](https://img.shields.io/github/stars/charmtv/vps-tcp-tune?style=flat-square)](https://github.com/charmtv/vps-tcp-tune/stargazers)
[![License](https://img.shields.io/github/license/charmtv/vps-tcp-tune?style=flat-square)](https://github.com/charmtv/vps-tcp-tune/blob/main/LICENSE)
[![Shell Script](https://img.shields.io/badge/Language-Shell-blue?style=flat-square)](https://github.com/charmtv/vps-tcp-tune)

<p>
一键安装 XanMod 内核 | 启用 BBR v3 拥塞控制 | 集成 36+ 实用工具
<br>
<b>为高性能 VPS 而生</b>
</p>

</div>

---

## ⚡ 极速安装 (Quick Start)

> **前置要求**：如果是新机器（Debian/Ubuntu），请先安装 curl：`apt update -y && apt install -y curl`

### ✅ 推荐方式 (Stable)

最稳定，不易出现 404 错误：

```bash
bash <(curl -fL [https://raw.githubusercontent.com/charmtv/vps-tcp-tune/main/install-alias.sh](https://raw.githubusercontent.com/charmtv/vps-tcp-tune/main/install-alias.sh))
```

安装完成后，**断开 SSH 重新连接**，或执行以下命令即可唤醒菜单：

```bash
bbr
```

---

<details>
<summary>🔻 <b>点击展开：备用安装方案 / 404 修复</b></summary>

### 🛡️ 方案 B：GitHub Raw 直链
如果上方命令无法连接，请尝试：

```bash
bash <(curl -fL [https://github.com/charmtv/vps-tcp-tune/raw/main/install-alias.sh](https://github.com/charmtv/vps-tcp-tune/raw/main/install-alias.sh))
```

### 📦 方案 C：手动下载运行
最安全的方式：

```bash
curl -fL -o net-tcp-tune.sh [https://raw.githubusercontent.com/charmtv/vps-tcp-tune/main/net-tcp-tune.sh](https://raw.githubusercontent.com/charmtv/vps-tcp-tune/main/net-tcp-tune.sh)
chmod +x net-tcp-tune.sh
./net-tcp-tune.sh
```

</details>

---

## 🛠️ 最佳实践流程 (Best Practices)

> ⚠️ **警告**：本脚本涉及内核与网络底层修改，建议在 **KVM / Xen** 架构使用。OpenVZ/LXC 容器暂不支持。

请按照以下顺序操作，以获得最佳效果：

| 步骤 | 模块 | 操作说明 |
| :--- | :--- | :--- |
| **Step 1** | **更换内核** | 选择 **功能 1** 安装 XanMod 内核 + BBRv3。<br>🔴 **安装后必须重启 VPS** |
| **Step 2** | **拥塞控制** | 重启后输入 `bbr`，选择 **功能 3** 进行调优。<br>✅ *小白选自动；进阶建议手动选 500M/700M 档位。* |
| **Step 3** | **网络优化** | 选择 **功能 4** (MTU/MSS 优化)。<br>💡 *有效解决丢包、断流问题。* |
| **Step 4** | **DNS (可选)** | 选择 **功能 5** 进行 DNS 净化。<br>⚠️ *高风险操作，请确保有 VNC 救砖能力。* |

---

## 📋 功能概览

脚本集成了 **36 项** 实用功能，主要分为以下五大类：

* 🖥️ **系统内核**：XanMod / BBR v3 / 官方内核切换
* 🌐 **网络调优**：ECN / SOS / 队列算法 / MTU 检测
* 🛡️ **系统运维**：Swap 管理 / 软件源修复 / 时间同步
* 📊 **测试工具**：三网测速 / 回程路由 / 性能跑分
* 🚀 **代理工具**：WARP / Gost / Snell 等一键管理

---

## ❓ 常见问题 (FAQ)

<details>
<summary><b>Q: 运行 `bbr` 提示 command not found？</b></summary>

**A:** 环境变量未刷新。请执行：
```bash
source ~/.bashrc
```
或者直接断开 SSH 连接，重新登录即可。
</details>

<details>
<summary><b>Q: 安装时出现 curl: (22) 404？</b></summary>

**A:** 这是因为部分网络对带时间戳的 URL 支持不佳。
请直接使用本文档顶部的 **[推荐方式]** 命令，不要使用旧版带 `?date` 参数的命令。
</details>

<details>
<summary><b>Q: 支持哪些系统？</b></summary>

**A:**
* ✅ Ubuntu 18.04+
* ✅ Debian 10+
* ✅ x86_64 / ARM64 架构
</details>

---

## ⭐ Star History

如果你觉得好用，请点击右上角 **Star** 支持！Fork 维护不易，感谢你的鼓励。

[![Star History Chart](https://api.star-history.com/svg?repos=Nyrazzy/vps-tcp-tune&type=Date)](https://www.star-history.com/#Nyrazzy/vps-tcp-tune&Date)
