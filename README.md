# i3-dotfiles

My i3 desktop configs, symlinked into `~/.config` so a `git pull` keeps them in sync.

## Configs

Configuration files can be found within `config` folder.

## Packages

| Package | Description |
|---------|-------------|
| `i3` | Tiling window manager |
| `picom` | Compositor (shadows, transparency) |
| `rofi` | Application launcher |
| `pywal` | Generates color schemes from wallpaper |
| `scrot` | Screenshot utility |
| `xclip` | Clipboard access from the command line |
| `yad` | Dialog boxes for shell scripts |
| `alacritty` | GPU-accelerated terminal |
| `polybar` | Status bar |
| `feh` | Wallpaper setter and image viewer |
| `nitrogen` | Wallpaper browser/setter |
| `nemo` | File manager |

## Install

```bash
git clone https://github.com/feleiro/i3-dotfiles.git
cd i3-dotfiles
./ricer -i    # install packages + symlink configs
./ricer -u    # remove symlinks
./ricer -h    # help
```

Supports Arch, Void, and Slackware. Existing configs are backed up as `<name>.backup-<timestamp>`.
