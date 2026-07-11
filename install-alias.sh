#!/usr/bin/env bash

set -u

readonly RAW_URL="https://raw.githubusercontent.com/charmtv/vps-tcp-tune/main/net-tcp-tune.sh"
readonly FALLBACK_URL="https://github.com/charmtv/vps-tcp-tune/raw/main/net-tcp-tune.sh"
readonly BLOCK_BEGIN="# >>> vps-tcp-tune >>>"
readonly BLOCK_END="# <<< vps-tcp-tune <<<"

readonly YELLOW='\033[1;33m'
readonly GREEN='\033[1;32m'
readonly CYAN='\033[1;36m'
readonly RED='\033[1;31m'
readonly NC='\033[0m'

MODE="${1:-install}"
RC_FILE=""
TEMP_FILE=""

cleanup() {
    if [ -n "$TEMP_FILE" ] && [ -f "$TEMP_FILE" ]; then
        rm -f "$TEMP_FILE"
    fi
}

trap cleanup EXIT

die() {
    printf '%b错误：%s%b\n' "$RED" "$*" "$NC" >&2
    exit 1
}

detect_rc_file() {
    local current_shell="${SHELL:-bash}"
    current_shell="${current_shell##*/}"

    case "$current_shell" in
        zsh)
            RC_FILE="$HOME/.zshrc"
            ;;
        bash)
            RC_FILE="$HOME/.bashrc"
            ;;
        *)
            RC_FILE="$HOME/.bashrc"
            ;;
    esac

    mkdir -p "$(dirname "$RC_FILE")" || die "无法创建配置目录。"
    touch "$RC_FILE" || die "无法写入 $RC_FILE。"
}

strip_managed_blocks() {
    local input_file="$1"
    local output_file="$2"

    awk -v begin="$BLOCK_BEGIN" -v end="$BLOCK_END" '
        $0 == begin { managed = 1; next }
        $0 == end { managed = 0; next }
        managed { next }

        legacy {
            if ($0 ~ /^alias bbr=/) {
                legacy = 0
            }
            next
        }

        $0 == "# ========================================" {
            if ((getline next_line) > 0) {
                if (next_line ~ /^# net-tcp-tune 快捷别名/) {
                    legacy = 1
                    next
                }
                print
                print next_line
                next
            }
        }

        $0 ~ /^# net-tcp-tune 快捷别名/ { legacy = 1; next }
        $0 ~ /^alias bbr=.*net-tcp-tune\.sh/ { next }
        { print }
    ' "$input_file" >"$output_file"
}

write_managed_block() {
    cat <<'EOF' | sed \
        -e "s|__RAW_URL__|$RAW_URL|g" \
        -e "s|__FALLBACK_URL__|$FALLBACK_URL|g"
# >>> vps-tcp-tune >>>
bbr() {
    local primary_url="__RAW_URL__"
    local fallback_url="__FALLBACK_URL__"
    local script_file exit_code

    command -v curl >/dev/null 2>&1 || {
        printf '错误：缺少 curl，请先安装 curl。\n' >&2
        return 1
    }

    script_file="$(mktemp)" || return 1
    if ! curl -fsSL --connect-timeout 10 --max-time 120 --retry 2 \
        --retry-delay 1 -o "$script_file" "$primary_url"; then
        : >"$script_file"
        if ! curl -fsSL --connect-timeout 10 --max-time 120 --retry 2 \
            --retry-delay 1 -o "$script_file" "$fallback_url"; then
            printf '错误：主脚本下载失败，请检查网络或 GitHub 连接。\n' >&2
            rm -f "$script_file"
            return 1
        fi
    fi

    if [ ! -s "$script_file" ] || ! bash -n "$script_file"; then
        printf '错误：下载内容不是有效的 Bash 脚本。\n' >&2
        rm -f "$script_file"
        return 1
    fi

    bash "$script_file" "$@"
    exit_code=$?
    rm -f "$script_file"
    return "$exit_code"
}
# <<< vps-tcp-tune <<<
EOF
}

replace_config() {
    local include_block="$1"

    TEMP_FILE="$(mktemp)" || die "无法创建临时文件。"
    strip_managed_blocks "$RC_FILE" "$TEMP_FILE" || die "清理旧配置失败。"

    if [ "$include_block" = "yes" ]; then
        while [ -s "$TEMP_FILE" ] && [ -z "$(tail -n 1 "$TEMP_FILE")" ]; do
            sed -i '$d' "$TEMP_FILE"
        done
        [ ! -s "$TEMP_FILE" ] || printf '\n' >>"$TEMP_FILE"
        write_managed_block >>"$TEMP_FILE"
    fi

    if cmp -s "$RC_FILE" "$TEMP_FILE"; then
        return 1
    fi

    cp "$RC_FILE" "${RC_FILE}.bak.$(date +%Y%m%d_%H%M%S)" \
        || die "备份 $RC_FILE 失败。"
    mv "$TEMP_FILE" "$RC_FILE" || die "更新 $RC_FILE 失败。"
    TEMP_FILE=""
    return 0
}

install_command() {
    command -v curl >/dev/null 2>&1 || die "缺少 curl，请先安装 curl。"

    if replace_config yes; then
        printf '%b快捷命令已安装或更新。%b\n' "$GREEN" "$NC"
    else
        printf '%b快捷命令已经是最新配置。%b\n' "$YELLOW" "$NC"
    fi

    printf '配置文件：%s\n' "$RC_FILE"
    printf '立即生效：%bsource %s%b\n' "$CYAN" "$RC_FILE" "$NC"
    printf '运行菜单：%bbbr%b\n' "$GREEN" "$NC"
}

uninstall_command() {
    if replace_config no; then
        printf '%b快捷命令已卸载。%b\n' "$GREEN" "$NC"
        printf '立即生效：%bsource %s%b\n' "$CYAN" "$RC_FILE" "$NC"
    else
        printf '%b未找到受管的 bbr 快捷命令。%b\n' "$YELLOW" "$NC"
    fi
}

case "$MODE" in
    install)
        detect_rc_file
        install_command
        ;;
    uninstall)
        detect_rc_file
        uninstall_command
        ;;
    *)
        die "未知参数：$MODE。可用参数：install、uninstall。"
        ;;
esac
