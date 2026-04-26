# Dotfiles

A minimalist configuration management system using the **Bare Git Repository** method.
This allows managing dotfiles in the home directory without the clutter of symlinks or a visible `.git` folder in `$HOME`.
This repo is based on [this Atlassian article](https://www.atlassian.com/git/tutorials/dotfiles).

## Purpose

The goal of this setup is to provide a portable, dependency-free way to version control personal configuration files.
By using a bare repository and a custom alias, we can track files directly in the `$HOME` directory while keeping the Git metadata isolated in a separate folder (`~/.dotfile_cfg`).

## Current software configs

| Software | Directory |
| :--- | :--- |
| Alacritty | `.config/alacritty` |

## Installation

There are two scripts depending on your use case.

### `track.sh` — Full tracking setup (recommended for your own machine)

Clones the repo, checks out config files, backs up any conflicts, and registers the `dotfile_config` alias in your `.zshrc` so you can commit changes going forward.

```bash
curl -Lks https://raw.githubusercontent.com/ahll19/dotfiles/main/track.sh | zsh -s -- https://github.com/ahll19/dotfiles.git
```

### `install.sh` — Quick install (for machines you don't actively develop on)

Clones the repo and checks out config files only. No alias is added to your shell. Useful for deploying your config onto a remote server or a temporary machine.

```bash
curl -Lks https://raw.githubusercontent.com/ahll19/dotfiles/main/install.sh | zsh -s -- https://github.com/ahll19/dotfiles.git
```

> Both scripts will automatically detect conflicting local files and back them up to `~/.config-backup-<timestamp>` before checking out.

## Usage

After running `track.sh`, use the `dotfile_config` alias instead of `git` for managing your dotfiles:

| Command | Description |
| :--- | :--- |
| `dotfile_config status` | Check which dotfiles are modified |
| `dotfile_config add .zshrc` | Stage a file for tracking |
| `dotfile_config commit -m "update"` | Commit changes |
| `dotfile_config push` | Push changes to the remote repository |

**Note:** Untracked files in your `$HOME` directory are hidden by default to keep the `status` command clean.
Only files you explicitly `add` will be tracked.
