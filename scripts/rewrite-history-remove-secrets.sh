#!/bin/bash
# 用「全新单提交」重写历史，去掉之前提交里的隐私数据。
# 执行前请确认：当前工作区里的敏感信息已经全部删干净。
# 执行后需要 force push 到 GitHub。

set -e
cd "$(git rev-parse --show-toplevel)"

echo "当前分支: $(git branch --show-current)"
echo "当前提交数: $(git rev-list --count HEAD)"
read -p "确认当前工作区已无敏感信息？将用当前文件生成全新历史。(y/N) " ok
[[ "$ok" != "y" && "$ok" != "Y" ]] && echo "已取消" && exit 0

# 备份当前 main（可选，便于恢复）
git branch backup-before-rewrite 2>/dev/null || true

# 新建无历史的孤儿分支，用当前工作区做唯一提交
git checkout --orphan new-main
git add -A
git commit -m "feat: Apollo 达梦数据库适配版 - 基于 Apollo 2.1.0，适配达梦 DM"

# 用新分支替换 main
git branch -D main
git branch -m main

echo ""
echo "历史已重写为 1 个提交。接下来请执行："
echo "  git push origin main --force"
echo ""
echo "注意：--force 会覆盖 GitHub 上的历史。若其他人已 clone，需让他们重新 clone 或 rebase。"
