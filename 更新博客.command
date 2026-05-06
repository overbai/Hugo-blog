#!/bin/bash
cd /Users/$(whoami)/Hugo-blog
git pull origin main
git add .
git commit -m "Auto update blog posts"
git push origin main
echo "博客更新成功！可以关闭窗口了。"
read -p "按任意键退出..."