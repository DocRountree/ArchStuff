#!/usr/bin/env bash
# Refuse to let secrets or personal files into the repo.
#
# Usage: tools/check-secrets.sh                 scan files staged for commit
#        tools/check-secrets.sh --all           scan every tracked and untracked file
#        tools/check-secrets.sh --install-hook  run the staged scan before every commit
set -euo pipefail

top=$(git rev-parse --show-toplevel)
cd "$top"

if [[ ${1:-} == --install-hook ]]; then
    hook=$(git rev-parse --git-path hooks)/pre-commit
    printf '#!/bin/sh\nexec "%s" \n' "$(realpath --relative-to="$top" "${BASH_SOURCE[0]}")" > "$hook"
    chmod +x "$hook"
    echo "Installed $hook"
    exit 0
fi

if [[ ${1:-} == --all ]]; then
    mapfile -t files < <(git ls-files --cached --others --exclude-standard)
else
    mapfile -t files < <(git diff --cached --name-only --diff-filter=ACMR)
fi

# Files that exist on purpose: the live ISO's user database (empty passwords by design).
allow='^(greenleaf/)?profile/airootfs/etc/(shadow|gshadow|passwd|group)$'   # works in ArchStuff and in the Greenleaf repo

bad_names='(^|/)(id_(rsa|dsa|ecdsa|ed25519)(\.pub)?|\.netrc|\.pgpass|.*\.(pem|key|p12|pfx|kdbx|gpg|asc)|known_hosts|authorized_keys|.*\.nmconnection|system-connections/.*|\.env(\..*)?|credentials(\.json)?|\.git-credentials)$'
bad_content='-----BEGIN [A-Z ]*PRIVATE KEY-----|gh[pousr]_[A-Za-z0-9]{36}|github_pat_[A-Za-z0-9_]{20,}|sk-ant-[A-Za-z0-9_-]{20,}|AKIA[0-9A-Z]{16}|xox[abprs]-[A-Za-z0-9-]{10,}|AIza[0-9A-Za-z_-]{35}|^\s*psk\s*=|/home/[a-z_][a-z0-9_-]*/'

fail=0
for f in "${files[@]}"; do
    [[ -f $f ]] || continue
    [[ $f =~ $allow ]] && continue
    if [[ $f =~ $bad_names ]]; then
        echo "BLOCKED (file type): $f"; fail=1; continue
    fi
    if grep -IEnq -- "$bad_content" "$f"; then
        grep -IEn -- "$bad_content" "$f" | sed "s|^|BLOCKED ($f): |" | cut -c1-160
        fail=1
    fi
done

if [[ $fail -ne 0 ]]; then
    echo
    echo "Secret or personal data found. Remove it, or if it's a false alarm, adjust tools/check-secrets.sh."
    exit 1
fi
echo "No secrets found in ${#files[@]} file(s)."
