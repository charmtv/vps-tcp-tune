#!/usr/bin/env bash

set -Eeuo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
SCRIPT="$ROOT_DIR/net-tcp-tune.sh"

assert_contains() {
    local text="$1"
    local label="$2"

    grep -Fq "$text" "$SCRIPT" || {
        printf '失败：%s\n' "$label" >&2
        exit 1
    }
    printf '通过：%s\n' "$label"
}

assert_not_contains() {
    local text="$1"
    local label="$2"

    if grep -Fq "$text" "$SCRIPT"; then
        printf '失败：%s\n' "$label" >&2
        exit 1
    fi
    printf '通过：%s\n' "$label"
}

assert_contains "米粒 VPS TCP Tune - BBR v3 管理菜单" "菜单标题包含米粒"
assert_contains "https://raw.githubusercontent.com/charmtv/ml-bbrv3/main/install.sh" "ARM64 使用最新维护安装器"
assert_contains 'version="1.13.14"' "sing-box 回退版本已更新"
assert_contains "https://raw.githubusercontent.com/kejilion/sh/main/kejilion.sh" "科技 Lion 使用官方最新脚本"
assert_not_contains "jhb.ovh/jb/bbrv3arm.sh.sha256" "移除失效 ARM64 校验地址"
assert_not_contains "bash <(curl -sL kejilion.sh)" "移除失效科技 Lion 入口"
