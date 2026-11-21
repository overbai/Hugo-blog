#!/bin/bash
cd "$(dirname "$0")"
git pull origin main
git add .
git diff --cached --quiet || git commit -m "Auto update blog posts"
git push origin main
echo ""
echo "✅ 博客更新成功！按任意键关闭窗口..."
read -n 1 -s -r