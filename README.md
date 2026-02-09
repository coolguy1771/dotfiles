# dotfiles

Dotfiles managed by chezmoi.

## First-time setup

One command (clone, init config, apply dotfiles and run scripts):

```sh
chezmoi init --apply https://github.com/coolguy1771/dotfiles.git
```

Or with SSH:

```sh
chezmoi init --apply git@github.com:coolguy1771/dotfiles.git
```

`init` will prompt for machine-specific data (e.g. personal vs work). Then chezmoi will write config under `~/.config/chezmoi/`, apply all source files, and run setup scripts in order: nano syntax highlighter, and on macOS, `brew bundle` when the Brewfile has changed.

## Apply after changes

```sh
chezmoi apply
```

## Inspect or diff

```sh
chezmoi diff    # what would change
chezmoi status # managed files and script run status
```
