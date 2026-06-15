#!/bin/zsh
AUTO_EXEC_FILES=("ob-runtime")

cd() {
  builtin cd "$@" || return
  _check_auto_exec_files
}

_check_auto_exec_files() {
  for file in "${AUTO_EXEC_FILES[@]}"; do
    if [[ -f "$file" && -x "$file" ]]; then
      read -r -k 1 "REPLY?Execute ./$file? (Y/n) "
      echo
      
      if [[ ! "$REPLY" =~ ^[Nn]$ ]]; then
        ./"$file"
      fi
    fi
  done
}

_check_auto_exec_files
