# dotfiles

My personal dotfiles, managed by [chezmoi](https://www.chezmoi.io/).

Tested on macOS and Archlinux.

## How to use

### Install chezmoi
```
# macOS
brew install chezmoi

# Archlinux
pacman -S chezmoi
```

### First time
```
$ chezmoi init https://github.com/Liangtaiwan/dotfiles.git
$ chezmoi apply
```
You will be prompted for `name` and `email` (used in `~/.gitconfig`).

### Update
```
$ chezmoi update
```

## Zsh

Plugin manager: [zplug](https://github.com/b4b4r07/zplug). Auto-installs on
first run.

### prompt theme

[Powerlevel10k](https://github.com/romkatv/powerlevel10k) configured in
Pure style. See `dot_p10k.zsh` for the config; run `p10k configure` to
regenerate.

### plugins

- [zsh-async](https://github.com/mafredri/zsh-async)
- [vim.zsh](https://github.com/leomao/vim.zsh)
- [powerlevel10k](https://github.com/romkatv/powerlevel10k)
- [enhancd](https://github.com/b4b4r07/enhancd)
- [zsh-completions](https://github.com/zsh-users/zsh-completions)
- [zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting)
- [diff-so-fancy](https://github.com/so-fancy/diff-so-fancy)

### Related tools

- [fzf](https://github.com/junegunn/fzf)
- [rg](https://github.com/BurntSushi/ripgrep) or [ag](https://github.com/ggreer/the_silver_searcher)
- [eza](https://github.com/eza-community/eza) or [lsd](https://github.com/lsd-rs/lsd)

### Customization

Put your customization in `~/.zshenv.local` and `~/.zshrc.local`.

## Tmux

Plugins managed by [tpm](https://github.com/tmux-plugins/tpm):
- [tmux-copycat](https://github.com/tmux-plugins/tmux-copycat)
- [tmux-yank](https://github.com/tmux-plugins/tmux-yank)
- [tmux-resurrect](https://github.com/tmux-plugins/tmux-resurrect)

## Git

One can add custom settings in `~/.gitconfig.local`.
Uses [diff-so-fancy](https://github.com/so-fancy/diff-so-fancy) as the
pager of `git diff` and `git show`.

## Ghostty

Config at `~/.config/ghostty/config`. Catppuccin Mocha palette,
google sans code, background opacity 0.9.

## Karabiner (macOS)

Config at `~/.config/karabiner/`.

## Fontconfig (Linux)

For Traditional Chinese users on Archlinux primarily. Requires:
- one of "Noto Sans CJK TC", "Source Han Sans TW", "Source Han Sans TC"
- "Source Code Pro" or "Inconsolata"

```console
# pacman -S noto-fonts-cjk adobe-source-code-pro-fonts
```

## iTerm2 (legacy)

`iterm2_profile.json` is not deployed by chezmoi — import manually via
iTerm2 → Preferences → Profiles → Other Actions → Import JSON Profiles.
