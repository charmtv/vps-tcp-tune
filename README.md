# VPS TCP Tune

面向 Debian/Ubuntu VPS 的网络调优与运维脚本，集成 XanMod、BBR v3、MTU/MSS 优化、代理管理和网络检测工具。

## 支持范围

| 项目 | 支持范围 |
| --- | --- |
| 系统 | Debian 10+、Ubuntu 18.04+ |
| 架构 | x86_64、ARM64 |
| 虚拟化 | KVM、Xen；不支持 OpenVZ/LXC 更换内核 |

脚本会修改内核、网络和系统配置。运行前请保留可用的 SSH/VNC/控制台连接。

## 一键安装

安装或更新 `bbr` 快捷命令：

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/charmtv/vps-tcp-tune/main/install-alias.sh)
```

重新登录 SSH，或立即加载配置：

```bash
source ~/.bashrc
bbr
```

使用 zsh 时执行 `source ~/.zshrc`。

不安装快捷命令，直接运行主脚本：

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/charmtv/vps-tcp-tune/main/net-tcp-tune.sh)
```

## 菜单分类

- 内核与网络：XanMod、BBR v3、MTU/MSS、DNS、Realm
- 系统配置：IP 优先级、IPv6、Swap、系统状态
- 转发与代理：Realm、Xray、Snell、SOCKS5、Sub-Store、反向代理
- 测试与检测：带宽、延迟、回程、IP 质量、流媒体与 AI 解锁
- 第三方工具：常用转发和系统脚本入口

原有功能编号保持不变。

## 推荐流程

1. 选择 `1` 安装或更新 XanMod + BBR v3。
2. 重启服务器，再运行 `bbr`。
3. 选择 `3` 执行 BBR 直连/落地优化。
4. 按需使用 `4` 进行 MTU/MSS 检测。

## 快捷命令管理

重复执行安装命令会自动更新旧版或失效的 `bbr` 配置。

卸载快捷命令：

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/charmtv/vps-tcp-tune/main/install-alias.sh) uninstall
```

更多说明见 [快速指南](QUICK_START.md)。

## 许可证

MIT
