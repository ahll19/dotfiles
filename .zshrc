# Work ================================================
export VAGRANT_WSL_ENABLE_WINDOWS_ACCESS="1"
export PATH=$PATH:/usr/local/go/bin:/home/anders/go/bin
export WIN_HOME=/mnt/c/Users/ahll
# =====================================================

export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="ys"
HYPHEN_INSENSITIVE="true"
ENABLE_CORRECTION="true"
COMPLETION_WAITING_DOTS="true"
DISABLE_UNTRACKED_FILES_DIRTY="true"
HIST_STAMPS="yyyy-mm-dd"

zstyle ':omz:update' mode auto      # update automatically without asking

plugins=(
  git
  rust
  ssh
  gh
  command-not-found
  docker
  docker-compose
  dotenv
)

source $ZSH/oh-my-zsh.sh
eval "$(zellij setup --generate-auto-start zsh)"
eval "$(fzf --zsh)"

alias opencode="ollama launch opencode"
alias dotfile_config='git --git-dir=$HOME/.dotfile_cfg --work-tree=$HOME'
