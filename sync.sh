#!/usr/bin/env sh

# 确保脚本抛出遇到的错误
set -e

cd docs/
git add -A 
git commit -m 'new post'
git push git@github.com:looker53/blog.git master

# 如果发布到 https://<USERNAME>.github.io/<REPO>
# git push -f git@github.com:<USERNAME>/<REPO>.git master:gh-pages

cd -