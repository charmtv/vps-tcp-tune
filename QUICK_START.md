# 快速指南

## 安装

```bash
bash <(curl -fsSL https://bbr.813099.xyz)
```

域名入口由 Cloudflare Worker 提供，GitHub Raw 作为自动备用源。

让快捷命令立即生效：

```bash
# Bash
source ~/.bashrc

# zsh
source ~/.zshrc
```

运行菜单：

```bash
bbr
```

重复运行安装命令会替换旧版配置，可用于修复失效别名。

## 直接运行

不安装快捷命令：

```bash
bash <(curl -fsSL https://bbr.813099.xyz/net-tcp-tune.sh)
```

下载到本地：

```bash
curl -fsSLo net-tcp-tune.sh https://bbr.813099.xyz/net-tcp-tune.sh
chmod +x net-tcp-tune.sh
./net-tcp-tune.sh
```

## 卸载快捷命令

```bash
bash <(curl -fsSL https://bbr.813099.xyz) uninstall
```

执行后重新加载 Shell 配置或重新登录。

## 常见问题

### `bbr: command not found`

运行 `source ~/.bashrc` 或 `source ~/.zshrc`，也可以重新登录 SSH。

### GitHub 下载失败

确认 `curl` 可用并测试连接：

```bash
curl -I https://bbr.813099.xyz/net-tcp-tune.sh
```

安装后的 `bbr` 命令会自动尝试 GitHub Raw 和 GitHub 备用地址，并拒绝执行空文件或语法错误的下载内容。
