#!/usr/bin/env bash
# 허용된 파일만 있는지, 비밀값처럼 보이는 문자열이 없는지 검사한다.
set -euo pipefail
cd "$(dirname "$0")/.."
bad=0
while IFS= read -r f; do
  case "$f" in
    *.html|*.css|*.md|*.sh|.gitignore|.nojekyll|CNAME) ;;
    *) echo "허용되지 않은 파일: $f"; bad=1 ;;
  esac
done < <(git ls-files; git ls-files --others --exclude-standard)
if grep -rniE 'serviceKey=|DATA_GO_KR|BEGIN (RSA|EC|PRIVATE)|AKIA[0-9A-Z]{16}|gho_[A-Za-z0-9]{20,}' . --exclude-dir=.git --exclude=check.sh; then
  echo "비밀값으로 보이는 문자열이 있습니다."; bad=1
fi
[ $bad -eq 0 ] && echo "검사 통과"
exit $bad
