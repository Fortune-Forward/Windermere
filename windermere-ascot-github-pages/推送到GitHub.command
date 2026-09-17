#!/bin/bash
# ------------------------------------------------------------
# 把 The Windermere 中文展示页推送到 GitHub 仓库
# 用法：把这个文件放进解压后的文件夹（和 index.html 同一层），双击运行
# ------------------------------------------------------------

REPO="https://github.com/Fortune-Forward/Windermere-.git"
BRANCH="main"

cd "$(dirname "$0")" || exit 1

echo "=============================================="
echo " 推送目标：$REPO"
echo " 当前目录：$(pwd)"
echo "=============================================="
echo

# --- 检查文件是否齐全 ---
if [ ! -f "index.html" ]; then
  echo "❌ 没找到 index.html。"
  echo "   请把这个脚本放到解压后的文件夹里（和 index.html 同一层）再运行。"
  echo
  read -p "按回车键关闭…" ; exit 1
fi

if [ ! -d "assets" ]; then
  echo "⚠️  没找到 assets 文件夹，视频将无法播放。"
  read -p "仍要继续？(y/n) " go
  [ "$go" != "y" ] && exit 1
fi

echo "✅ index.html 已找到（$(du -h index.html | cut -f1)）"
[ -d "assets" ] && echo "✅ assets 已找到（$(ls assets | wc -l | tr -d ' ') 个文件，$(du -sh assets | cut -f1)）"
echo

# --- 检查 git ---
if ! command -v git >/dev/null 2>&1; then
  echo "❌ 这台电脑没有安装 git。"
  echo "   打开「终端」运行：xcode-select --install"
  echo "   装好之后再双击本脚本。"
  read -p "按回车键关闭…" ; exit 1
fi

# --- 初始化并提交 ---
[ ! -d ".git" ] && git init -q
git checkout -q -B "$BRANCH"

git remote remove origin 2>/dev/null
git remote add origin "$REPO"

touch .nojekyll
git add -A
git commit -q -m "Update The Windermere Chinese showcase page" || echo "（没有新的改动需要提交）"

echo
echo "正在推送…（第一次会要求登录 GitHub）"
echo

if git push -u origin "$BRANCH" --force; then
  echo
  echo "=============================================="
  echo " ✅ 推送成功"
  echo
  echo " 接下来去开启 GitHub Pages（只需做一次）："
  echo " 1. 打开 https://github.com/Fortune-Forward/Windermere-/settings/pages"
  echo " 2. Source 选 Deploy from a branch"
  echo " 3. 分支选 main，目录选 / (root)，点 Save"
  echo
  echo " 等一两分钟后访问："
  echo " https://fortune-forward.github.io/Windermere-/"
  echo "=============================================="
else
  echo
  echo "=============================================="
  echo " ❌ 推送失败，通常是登录问题。"
  echo
  echo " GitHub 已经不支持用账号密码推送，需要二选一："
  echo
  echo " 方式 A（推荐）：安装 GitHub CLI 登录一次"
  echo "   brew install gh"
  echo "   gh auth login        （选 GitHub.com → HTTPS → 用浏览器登录）"
  echo "   之后重新双击本脚本即可"
  echo
  echo " 方式 B：用个人访问令牌（Token）"
  echo "   1. 打开 https://github.com/settings/tokens"
  echo "   2. 生成一个勾选 repo 权限的 token"
  echo "   3. 重新运行本脚本，用户名填 GitHub 用户名，"
  echo "      密码栏粘贴那个 token（不是账号密码）"
  echo "=============================================="
fi

echo
read -p "按回车键关闭…"
