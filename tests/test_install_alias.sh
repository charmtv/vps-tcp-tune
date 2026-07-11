#!/usr/bin/env bash

set -Eeuo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
TEST_BASE="${TMPDIR:-/tmp}"
TEST_HOME="$(mktemp -d "$TEST_BASE/vps-tcp-tune-test.XXXXXX")"

cleanup() {
    case "$TEST_HOME" in
        "$TEST_BASE"/vps-tcp-tune-test.*)
            rm -rf "$TEST_HOME"
            ;;
    esac
}

trap cleanup EXIT

fail() {
    printf '失败：%s\n' "$*" >&2
    exit 1
}

assert_contains() {
    local file="$1"
    local text="$2"
    local label="$3"

    grep -Fq "$text" "$file" || fail "$label"
    printf '通过：%s\n' "$label"
}

mkdir -p "$TEST_HOME/bin"
TEST_PATH="$TEST_HOME/bin:$PATH"
cat >"$TEST_HOME/.bashrc" <<'EOF'
export KEEP_THIS_LINE=1
# ========================================
# net-tcp-tune 快捷别名 (自动添加)
# 使用旧地址
# ========================================
alias bbr="bash <(curl -fsSL https://raw.githubusercontent.com/Nyrazzy/vps-tcp-tune/main/net-tcp-tune.sh)"
EOF

cat >"$TEST_HOME/bin/curl" <<'EOF'
#!/usr/bin/env bash
set -u

output=""
url=""
while (($#)); do
    case "$1" in
        -o)
            output="$2"
            shift 2
            ;;
        http*)
            url="$1"
            shift
            ;;
        *)
            shift
            ;;
    esac
done

if [[ "$url" == https://raw.githubusercontent.com/* ]]; then
    exit 22
fi

cat >"$output" <<'SCRIPT'
#!/usr/bin/env bash
printf 'launcher:%s\n' "$*"
SCRIPT
EOF
chmod +x "$TEST_HOME/bin/curl"

HOME="$TEST_HOME" SHELL=/bin/bash PATH="$TEST_PATH" \
    bash "$ROOT_DIR/install-alias.sh" >/dev/null

assert_contains "$TEST_HOME/.bashrc" "export KEEP_THIS_LINE=1" "保留用户原配置"
assert_contains "$TEST_HOME/.bashrc" "# >>> vps-tcp-tune >>>" "写入新版配置块"
assert_contains "$TEST_HOME/.bashrc" "bbr()" "安装 bbr 下载函数"
if grep -Fq "Nyrazzy" "$TEST_HOME/.bashrc"; then
    fail "旧仓库地址应被清理"
fi
printf '通过：清理旧仓库地址\n'

before_hash="$(sha256sum "$TEST_HOME/.bashrc" | awk '{print $1}')"
HOME="$TEST_HOME" SHELL=/bin/bash PATH="$TEST_PATH" \
    bash "$ROOT_DIR/install-alias.sh" >/dev/null
after_hash="$(sha256sum "$TEST_HOME/.bashrc" | awk '{print $1}')"
[[ "$before_hash" == "$after_hash" ]] || fail "重复安装应保持配置不变"
printf '通过：重复安装保持幂等\n'

launcher_output="$({
    export PATH="$TEST_PATH"
    # shellcheck source=/dev/null
    source "$TEST_HOME/.bashrc"
    bbr alpha beta
})"
[[ "$launcher_output" == "launcher:alpha beta" ]] || fail "备用下载地址未正确执行"
printf '通过：主地址失败时使用备用地址\n'

HOME="$TEST_HOME" SHELL=/bin/bash PATH="$TEST_PATH" \
    bash "$ROOT_DIR/install-alias.sh" uninstall >/dev/null
if grep -Fq "vps-tcp-tune" "$TEST_HOME/.bashrc"; then
    fail "卸载后不应残留受管配置"
fi
assert_contains "$TEST_HOME/.bashrc" "export KEEP_THIS_LINE=1" "卸载后保留用户配置"
