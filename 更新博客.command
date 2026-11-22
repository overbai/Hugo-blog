#!/bin/bash
cd "$(dirname "$0")" || exit 1

echo "==== 望川博客 · 更新 ===="

echo "① 检查本机新文章…"
if [ -z "$(git status --porcelain)" ]; then
  echo "   本机无新改动"
else
  git status --short
  git add -A
  git commit -m "更新文章 $(date '+%m-%d %H:%M')"
  echo "   ✅ 本机改动已提交"
fi

echo "② 拉取线上最新…"
git pull --rebase origin main || echo "⚠️ pull 有问题，看上面报错"

echo "③ 同步主题…"
if [ -f .gitmodules ]; then
  git submodule update --init --recursive && echo "   ✅ 主题已对齐"
fi

echo "④ 推送到 GitHub…"
git push origin main && echo "   ✅ 已推送，Cloudflare 1-2 分钟自动部署"

echo "==== 更新完成 ✅ ===="
read -n 1 -s -r -p "按任意键关闭窗口…" < /dev/tty
