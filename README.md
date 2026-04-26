# Dotfiles

A minimalist configuration management system using the **Bare Git Repository** method.
This allows managing dotfiles in the home directory without the clutter of symlinks or a visible `.git` folder in `$HOME`.
This repo is based on [this Atlassian article](https://www.atlassian.com/git/tutorials/dotfiles)

## Purpose
The goal of this setup is to provide a portable,
dependency-free way to version control personal configuration files.
By using a bare repository and a custom alias,
we can track files directly in the `$HOME` directory while keeping the Git metadata isolated in a separate folder (`~/.cfg`).

## Current software configs
| Software | Directory |
| :--- | :--- |
| Alacritty | `.config/alacritty` |

### Installation

### Full Tracking Setup
Use this method to initialize your dotfiles on a new machine. This will clone the repository, backup any conflicting local files, and set up the necessary shell alias in your `.zshrc`.

```bash
curl -Lks https://raw.githubusercontent.com/ahll19/dotfiles/main/setup.sh | bash -s -- https://github.com/ahll19/dotfiles.git --track
```

### Quick Install (No Alias)
If you only need to deploy the files and perform a one-time sync without modifying your shell configuration:

```bash
curl -Lks https://raw.githubusercontent.com/ahll19/dotfiles/main/setup.sh | bash -s -- https://github.com/ahll19/dotfiles.git --install
```

## Usage
After installation, do not use standard `git` commands for your dotfiles. Instead, use the `dotfile_config` alias:

| Command | Description |
| :--- | :--- |
| `dotfile_config status` | Check which dotfiles are modified |
| `dotfile_config add .zshrc` | Stage a file for tracking |
| `dotfile_config commit -m "update"` | Commit changes |
| `dotfile_config push` | Push changes to the remote repository |

**Note:** Untracked files in your `$HOME` directory are hidden by default to keep the `status` command clean.
Only files you explicitly `add` will be tracked.
