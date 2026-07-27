# Dotfiles

My personal Arch Linux configuration files, managed as a **bare Git repository** whose work tree is `$HOME`. The repository lives at `$HOME/.dotfiles`. The `config` alias follows the Arch Wiki's [Tracking dotfiles directly with Git](https://wiki.archlinux.org/title/Dotfiles#Tracking_dotfiles_directly_with_Git) approach.

## Contents

| Area | Files | Notes |
| --- | --- | --- |
| Shell and session | `.bashrc`, `.bash_profile`, `.xinitrc`, `.local/bin/*` | Bash aliases, XDG variables, Starship prompt, `lf` integration, local helper scripts, and automatic `startx` from tty1. The X session starts `dwm`, `picom`, `clipmenud`, `numlockx`, Caps/Escape swap, and the screen-lock helper. |
| Git | `.config/git/config` | Main branch defaults, automatic upstream setup, and signed commits. Import or replace the configured GPG key before committing. |
| Terminal workflow | `.config/foot/foot.ini`, `.config/tmux/tmux.conf`, `.config/lf/*`, `.config/starship.toml` | Foot theme/transparency, tmux prefix/keybindings and X clipboard copying, lf icons/previews, and a compact Starship prompt. |
| Desktop bar | `.config/polybar/*`, `.config/wallpaper.jpg` | Polybar theme, DWM integration, network, Bluetooth, weather, battery, and multi-monitor launcher. |
| Editors and development | `.config/nvim/init.vim`, `.config/Code/User/*`, `.config/ruff/pyproject.toml` | Neovim basics; VS Code settings/keybindings for Git signing, Python/Ruff, C/C++, Go, and Vim; strict Ruff linting with NumPy docstrings. |
| Media and applications | `.config/mpv/*`, `.config/onedrive/config`, `.librewolf/librewolf.overrides.cfg`, `.config/gtk-3.0/settings.ini` | mpv volume and thumbnail scripts, OneDrive polling/venv exclusion, LibreWolf preferences, and GTK settings. |
| Node and Pi | `.config/npm/npmrc`, `.config/pi/agent/*` | XDG-based npm paths plus Pi settings, extensions, task agents, web-fetch dependencies, and PDF-reader scripts. |

## Install

> **Warning:** checking out a bare dotfiles repository writes directly into `$HOME`. Back up any conflicting files first.

```sh
git clone --bare -b main git@github.com:maxdswain/.dotfiles.git "$HOME/.dotfiles"
alias config='/usr/bin/git --git-dir="$HOME/.dotfiles" --work-tree="$HOME"'
config checkout
config config --local status.showUntrackedFiles no
```

Add the `config` alias to the new shell's `.bashrc` if it is not present yet. There is no `dotfiles` command; use `config status`, `config add <path>`, and `config commit` to manage this repository.

## Arch packages

The following command uses package names confirmed with `pacman` on the machine that produced these files. Install the pieces you use:

```sh
sudo pacman -S --needed \
  bash git fzf paru xclip lf tmux starship neovim mpv npm go \
  xorg-xinit xorg-xrandr xorg-xset picom clipmenu numlockx \
  xdg-desktop-portal-gtk feh networkmanager bluez-utils curl jq \
  onedrive-abraunegg foot ruff
```

Optional packages installed from the AUR on that machine include `ctpv-git` (lf previews) and `visual-studio-code-bin`:

```sh
paru -S --needed ctpv-git visual-studio-code-bin
```

`dwm`, `slock`, `xssstate`, and `polybar` currently resolve to locally installed paths (`/usr/local/bin` or `$GOPATH/bin`), not pacman-owned packages. Build/install compatible versions yourself before using the X session and bar; the source trees are not part of this repository. The tracked `.local/bin/xsidle.sh` helper launched by `.xinitrc` requires `xssstate` and `xset`.

For the configured font and bar icons, install a Nerd Font containing **FiraCode Nerd Font** and **Weather Icons**. Enable the services used by the status scripts when applicable:

```sh
sudo systemctl enable --now NetworkManager bluetooth
```

## Desktop setup

The configuration is X11/DWM-oriented. After installing the required window-manager and helper binaries, log in on tty1; `.bash_profile` runs `startx` there and `.xinitrc` starts the session. Start the bar separately when desired:

```sh
~/.config/polybar/launch.sh
```

The launcher assumes the external monitor is named `HDMI-1-1` and the internal display is `eDP-1`; adapt it for other hardware. The bar's weather script needs `curl`, `jq`, an OpenWeatherMap API key, and a city ID/name. Replace its embedded key and city with your own values before use.

Foot is a separate Wayland terminal configuration and is not started by `.xinitrc`.

## Tool-specific notes

- **Git:** commits are GPG-signed. Change `user.name`, `user.email`, and `signingkey` in `.config/git/config`, or import the matching secret key.
- **tmux:** clipboard bindings call `xclip`; use an X11 session or adjust them for Wayland.
- **OneDrive:** run `onedrive --synchronize` once and authenticate before enabling its monitor service. The tracked config skips `.venv` directories and polls every 30 seconds.
- **VS Code:** install the Ruff, C/C++, Vim, and desired Go extensions to use the referenced formatter/features.
- **Pi:** install Pi with `npm install -g --ignore-scripts @earendil-works/pi-coding-agent`, then use the tracked `.config/pi/agent/settings.json`. Its configured packages are `@gotgenes/pi-permission-system`, `@tintinweb/pi-tasks`, and `pi-codex-search`; the local web-fetch extension has its own `package.json`, and the PDF skill requires `PyMuPDF==1.27.2.2`.

## Updating the repository

```sh
config status
config add .bashrc .config/tmux/tmux.conf
config commit -m 'chore: update shell and tmux configuration'
config push
```
