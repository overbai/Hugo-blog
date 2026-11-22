#!/bin/bash
cd "$(dirname "$0")" || exit 1
ERR=0

echo "==== 望川博客 · 更新 ===="

echo "① 检查本机新文章…"
if [ -z "$(git status --porcelain)" ]; then
  echo "   本机无新改动"
else
  git status --short
  git add -A
  git commit -m "更新文章 $(date '+%m-%d %H:%M')" || ERR=1
fi

echo "② 拉取线上最新…"
git pull --rebase origin main || ERR=1

echo "③ 同步主题…"
if [ -f .gitmodules ]; then
  git submodule update --init --recursive || ERR=1
fi

echo "④ 推送到 GitHub…"
git push origin main || ERR=1

if [ "$ERR" = 0 ]; then
  echo ""
  echo "✅ 博客更新成功！窗口即将自动关闭…"
  sleep 2
  osascript -e 'tell application "Terminal" to close (every window whose name contains "更新博客")'
else
  echo ""
  echo "⚠️ 有步骤出错，窗口保留，请看上面报错"
  read -r -p "按回车键关闭…" < /dev/tty
fi
