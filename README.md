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

```bash
curl -Lks https://raw.githubusercontent.com/ahll19/dotfiles/main/setup.sh | zsh
```

Clones the repo, checks out config files, backs up any conflicts to `~/.config-backup-<timestamp>`, and registers the `dotfile_config` alias in `~/.zshrc`.

## Usage

After installation, use the `dotfile_config` alias instead of `git`:

| Command | Description |
| :--- | :--- |
| `dotfile_config status` | Check which dotfiles are modified |
| `dotfile_config add .zshrc` | Stage a file for tracking |
| `dotfile_config commit -m "update"` | Commit changes |
| `dotfile_config push` | Push changes to the remote repository |

**Note:** Untracked files in `$HOME` are hidden by default to keep `status` clean. Only files you explicitly `add` will be tracked.
