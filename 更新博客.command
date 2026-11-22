#!/bin/bash
cd "$(dirname "$0")" || exit 1

echo "=========================================="
echo "  望川博客 · 一键双向同步"
echo "  站点目录：$(pwd)"
echo "=========================================="

# 1. 先存本机改动（★必须第一步，否则 pull 会被未提交文件挡住★）
echo ""
echo "① 暂存本机新文章/改动…"
if [ -z "$(git status --porcelain)" ]; then
  echo "   本机无新改动"
else
  echo "   发现以下改动："
  git status --short
  git add -A
  git commit -m "本机同步 $(date '+%m-%d %H:%M')" \
    && echo "✅ 本机改动已提交到本地仓库"
fi

# 2. 拉线上最新，并把自己刚提交的改动 rebase 到最上面
echo ""
echo "② 拉取线上最新 (git pull --rebase)…"
git pull --rebase origin main || {
  echo "❌ pull 冲突！请手动处理：cd ~/hugo-blog && git status"
  read -n 1 -s -r -p "按任意键关闭…"; echo ""; exit 1
}

# 3. 同步主题实体
echo ""
echo "③ 同步主题 submodule…"
if [ -f .gitmodules ]; then
  git submodule update --init --recursive && echo "✅ 主题已对齐"
else
  echo "（无 submodule，跳过）"
fi

# 4. 推本机所有改动上 GitHub
echo ""
echo "④ 推送到 GitHub (git push)…"
git push origin main && echo "✅ 已推送到 GitHub"

echo ""
echo "=========================================="
echo "✅ 双向同步完成！"
echo "   GitHub → 本机：主题/文章已更新"
echo "   本机 → GitHub：新文章已上传"
echo "   Cloudflare 自动部署，稍等 1-2 分钟刷新 baijie.me"
echo "=========================================="
read -n 1 -s -r -p "按任意键关闭窗口…"
echo ""
