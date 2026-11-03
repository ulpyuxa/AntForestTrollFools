#!/bin/sh
set -eu

# fix4：请求体不得携带伪造的固定能量/活力数值（99999999 / 8888888），
# 这类与真实 H5 不一致的常量是极易被服务端规则命中的客户端指纹。

source_file="$(dirname "$0")/../antforest/AntForestManager.m"
entry_file="$(dirname "$0")/../PortEntry.m"

for f in "$source_file" "$entry_file"; do
  # 忽略纯注释行，只检查实际代码
  code="$(grep -Ev '^[[:space:]]*//' "$f")"
  if printf '%s\n' "$code" | grep -Eq '99999999|8888888'; then
    echo "❌ $f 仍包含伪造的固定数值 99999999/8888888" >&2
    grep -En '99999999|8888888' "$f" | grep -Ev ':[[:space:]]*//' >&2
    exit 1
  fi
  if printf '%s\n' "$code" | grep -Eq '"currentEnergy"|currentVitalityAmount'; then
    echo "❌ $f 仍在请求体中写入 currentEnergy/currentVitalityAmount" >&2
    grep -En '"currentEnergy"|currentVitalityAmount' "$f" | grep -Ev ':[[:space:]]*//' >&2
    exit 1
  fi
done

# queryFriendHomePage 两条发送路径仍需存在且结构完整
grep -Fq 'alipay.antforest.forest.h5.queryFriendHomePage' "$source_file"
grep -Fq '"skipWhackMole":false,"activityParam":{}}]}' "$source_file" || \
grep -Fq '\"skipWhackMole\":false,\"activityParam\":{}}]}' "$source_file"
grep -Fq '@"skipWhackMole": @NO, @"activityParam": @{} }' "$source_file"

echo "✅ Request fingerprint checks passed!"
