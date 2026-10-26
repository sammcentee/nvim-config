# nvim-config

Neovim configuration for Arch Linux in WSL2.

## Settings

`init.lua` makes these changes:

- Neovim shows line numbers and relative line numbers.
- Yank, delete, and put use the system clipboard (`clipboard=unnamedplus`).
- Neovim uses full RGB colors in the terminal (`termguicolors`).
- The background is black (`#000000`). The text colors do not change.
- The number of the current line is bold yellow (`#FFFF00`). This yellow is the same as the color of the VS Code cursor.
- The relative numbers above the cursor are muted blue. The relative numbers below the cursor are muted green.

## Welcome screen

`lua/welcome.lua` replaces the default intro with a large green NVIM wordmark and a muted version line. The version comes from the installed Neovim.

The new screen shows only when Neovim starts with an empty buffer that has no name. The screen does not show in these conditions:

- You start Neovim with a file name, for example `nvim notes.md`.
- Neovim runs in VS Code (the vscode-neovim extension).
- Neovim runs without a user interface (headless).
- The terminal is less than 50 columns wide or less than 13 lines high.

The screen closes when you push a key. The screen also closes when you go to a different buffer or when the size of the terminal changes.

## Requirements

- Neovim. The version in use is 0.12.6.
- `win32yank.exe` on the `PATH`. Neovim uses this tool for the system clipboard in WSL. The Windows installation of Neovim includes it in `C:\Program Files\Neovim\bin`.

## Install

1. Log in to GitHub with the GitHub CLI. This repository is private.

   ```sh
   gh auth login
   ```

2. If `~/.config/nvim` exists, move it to a backup location:

   ```sh
   mv ~/.config/nvim ~/.config/nvim.bak
   ```

3. Clone this repository into `~/.config/nvim`:

   ```sh
   gh repo clone sammcentee/nvim-config ~/.config/nvim
   ```
