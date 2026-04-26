#!/bin/zsh
set -euo pipefail

REPO_URL="${1:-}"
MODE="${2:-}"

GITDIR="$HOME/.cfg"
WORKTREE="$HOME"
ALIAS_NAME="dotfile_config"
ALIAS_CMD="git --git-dir=$GITDIR --work-tree=$WORKTREE"
ALIAS_LINE="alias $ALIAS_NAME='$ALIAS_CMD'"

usage() {
echo "Usage:"
echo "  setup.sh <repo-url> --track"
echo "  setup.sh <repo-url> --install"
exit 1
}

if [[ -z "$REPO_URL" || -z "$MODE" ]]; then
usage
fi

if [[ "$MODE" != "--track" && "$MODE" != "--install" ]]; then
usage
fi

if [[ -d "$GITDIR" ]]; then
echo "Repo already exists at $GITDIR, skipping clone"
else
echo "Cloning bare repo into $GITDIR"
git clone --bare "$REPO_URL" "$GITDIR"
fi

function dotcfg() {
git --git-dir="$GITDIR" --work-tree="$WORKTREE" "$@"
}

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

if [[ "$MODE" == "--track" ]]; then
echo "Setting up tracking mode..."

if ! grep -Fxq "$ALIAS_LINE" "$HOME/.zshrc"; then
echo "Adding alias to ~/.zshrc"
echo "$ALIAS_LINE" >> "$HOME/.zshrc"
fi

dotcfg config --local status.showUntrackedFiles no

echo ""
echo "Done. Restart your shell or run:"
echo "  source ~/.zshrc"
echo "Then use: $ALIAS_NAME status"

else
echo "Install mode complete."
fi

echo "Finished."