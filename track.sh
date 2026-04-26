#!/bin/zsh
# track.sh — Clone dotfiles bare repo and set up shell alias for ongoing tracking
set -euo pipefail

REPO_URL="${1:-}"
GITDIR="$HOME/.dotfile_cfg"
WORKTREE="$HOME"
ALIAS_NAME="dotfile_config"
ALIAS_CMD="git --git-dir=$GITDIR --work-tree=$WORKTREE"
ALIAS_LINE="alias $ALIAS_NAME='$ALIAS_CMD'"

usage() {
  echo "Usage: track.sh <repo-url>"
  echo ""
  echo "Clones the dotfiles bare repo, checks out config files,"
  echo "and registers the '$ALIAS_NAME' alias in ~/.zshrc."
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

dotcfg config --local status.showUntrackedFiles no

if ! grep -Fxq "$ALIAS_LINE" "$HOME/.zshrc"; then
  echo "Adding alias to ~/.zshrc..."
  echo "$ALIAS_LINE" >> "$HOME/.zshrc"
else
  echo "Alias already present in ~/.zshrc, skipping"
fi

echo ""
echo "Done. Restart your shell or run:"
echo "  source ~/.zshrc"
echo ""
echo "Then manage your dotfiles with:"
echo "  $ALIAS_NAME status"
echo "  $ALIAS_NAME add .config/someapp/config"
echo "  $ALIAS_NAME commit -m 'add config'"
echo "  $ALIAS_NAME push"
