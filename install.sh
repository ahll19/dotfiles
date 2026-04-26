#!/bin/zsh
# install.sh — Deploy dotfiles from origin/main (no alias, no tracking setup)
set -euo pipefail

REPO_URL="${1:-}"
GITDIR="$HOME/.dotfile_cfg"
WORKTREE="$HOME"

usage() {
  echo "Usage: install.sh <repo-url>"
  echo ""
  echo "Clones the dotfiles bare repo and checks out config files."
  echo "Conflicting local files are backed up automatically."
  exit 1
}

if [[ -z "$REPO_URL" ]]; then
  usage
fi

function dotcfg() {
  git --git-dir="$GITDIR" --work-tree="$WORKTREE" "$@"
}

if [[ -d "$GITDIR" ]]; then
  echo "Repo already exists at $GITDIR, skipping clone"
else
  echo "Cloning bare repo into $GITDIR..."
  git clone --bare "$REPO_URL" "$GITDIR"
fi

dotcfg config core.sparseCheckout true
mkdir -p "$GITDIR/info"
cat > "$GITDIR/info/sparse-checkout" <<EOF
/*
!README.md
!LICENSE.md
!setup.sh
!install.sh
!track.sh
EOF

echo "Checking out dotfiles..."
set +e
dotcfg checkout 2>checkout_err.log
STATUS=$?
set -e

if [[ $STATUS -ne 0 ]]; then
  BACKUP_DIR="$HOME/.config-backup-$(date +%Y%m%d%H%M%S)"
  echo "Conflicts detected. Backing up existing files to $BACKUP_DIR"
  mkdir -p "$BACKUP_DIR"
  grep -E "^\s+." checkout_err.log | awk '{print $1}' | while read -r file; do
    if [[ -e "$WORKTREE/$file" ]]; then
      mkdir -p "$BACKUP_DIR/$(dirname "$file")"
      mv "$WORKTREE/$file" "$BACKUP_DIR/$file"
    fi
  done
  echo "Retrying checkout..."
  dotcfg checkout
fi

rm -f checkout_err.log
echo "Done. Dotfiles installed."
