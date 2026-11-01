#!/bin/sh
set -eu

source_file="$(dirname "$0")/../antforest/AntForestManager.m"
entry_file="$(dirname "$0")/../PortEntry.m"
header_file="$(dirname "$0")/../antforest/AntForestManager.h"
makefile="$(dirname "$0")/../Makefile"

grep -Fq 'enableAutoOceanTasks' "$header_file"
grep -Fq 'oceanBridge' "$header_file"
grep -Fq 'queryOceanTaskList' "$header_file"
grep -Fq 'handleOceanTaskListResponse:' "$header_file"
grep -Fq 'receiveOceanTaskAward:' "$header_file"

grep -Fq 'handleOceanTaskListResponse:' "$source_file"
grep -Fq 'queryOceanTaskList' "$source_file"
grep -Fq '神奇海洋·任务探测' "$source_file"
grep -Fq 'antOceanTaskVOList' "$source_file"
grep -Fq 'ANTOCEAN_TASK' "$source_file"
grep -Fq 'alipay.antocean.ocean.h5.queryTaskList' "$source_file"

grep -Fq 'isOceanURL' "$entry_file"
grep -Fq 'toggleAutoOceanTasks:' "$entry_file"
grep -Fq '神奇海洋 · 已绑定海洋 H5 Bridge' "$entry_file"
grep -Fq 'AntForestPort-Ocean 收取日志' "$entry_file"

grep -Fq 'isSafeOceanTask' "$source_file"
grep -Fq 'sLastExecutedSceneCode containsString:@"OCEAN"' "$source_file"
grep -Fq 'queryOceanTaskListWithForce:YES' "$source_file"
# 风控修复（fix2）：海洋 RPC 不得再兜底到森林首页 Bridge，只允许真实海洋页面 Bridge
grep -Fq 'id bridge = [self oceanOnlyBridge];' "$source_file"
if grep -Fq 'self.oceanBridge ?: self.jsBridge;' "$source_file"; then
  echo "❌ 海洋 RPC 仍存在兜底到森林首页 Bridge 的用法（会触发风控）" >&2
  exit 1
fi
grep -Fq 'self.lastCleanedOceanUserId = nil;' "$source_file"
grep -Fq 'scanOceanForFriends:fr.allKeys' "$source_file"
grep -Fq 'cleanFriendOcean' "$entry_file"
grep -Fq 'lastCleanedOceanUserId' "$entry_file"

grep -Fq '$(VERSION).dylib' "$makefile"
grep -Fq '$(VERSION)-iOS14.dylib' "$makefile"

echo "✅ All Ocean automation checks passed successfully!"
