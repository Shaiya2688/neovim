# Neovim Installation Guide

## 1.&nbsp;&nbsp; Install Neovim Configurations

```sh
git clone -b ubuntu https://github.com/Shaiya2688/neovim ~/.config/nvim
```

## 2.&nbsp;&nbsp; Install Neovim Editor

### •&nbsp; Method 1:&nbsp; Install Neovim From Downloads

Downloads are available on the [Releases](https://github.com/neovim/neovim/releases) page.

* Latest [stable release](https://github.com/neovim/neovim/releases/latest)
    * [macOS x86_64](https://github.com/neovim/neovim/releases/latest/download/nvim-macos-x86_64.tar.gz)
    * [macOS arm64](https://github.com/neovim/neovim/releases/latest/download/nvim-macos-arm64.tar.gz)
    * [Linux x86_64](https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz)
    * [Linux arm64](https://github.com/neovim/neovim/releases/latest/download/nvim-linux-arm64.tar.gz)
    * [Windows](https://github.com/neovim/neovim/releases/latest/download/nvim-win64.msi)

**Install latest release version for Linux systems**

```sh
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
sudo rm -rf /opt/nvim
sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz
```

Then add this to your shell config (`~/.bashrc`, `~/.zshrc`, ...):

    export PATH="$PATH:/opt/nvim-linux-x86_64/bin"

If latest release version is not compatible with your platform, you can try selecting an earlier version.

Alternatively, you can install from package (**Preferred**).

### •&nbsp; Method 2:&nbsp; Install Neovim From Package

Neovim stable are available on the [snap store](https://snapcraft.io/nvim).

**Install Stable Builds**

```sh
sudo apt-get update
sudo apt-get install snap
sudo snap install nvim --classic
```

If you previously installed Neovim via `apt-get`, it is recommended to uninstall the old version first:

```sh
sudo apt-get remove neovim
```

Alternatively, ensure that the Neovim installed via `snap` runs preferentially. You can confirm this by checking if `which nvim` returns `/snap/bin/nvim`.
If not, you can edit your shell config (`~/.bashrc`, `~/.zshrc`, ...) to ensure that `/snap/bin` is at the front of the `$PATH`:

    export PATH="/snap/bin:$PATH"

If no package is provided for your platform, you can build Neovim from source.


### •&nbsp; Method 3:&nbsp; Install Neovim From Source

**Install Build Prerequisites**

- General requirements:
  - Clang or GCC version 4.9+
  - CMake version 3.16+, built with TLS/SSL support
    - Optional: Get the latest CMake from https://cmake.org/download/
      - Provides a shell script which works on most Linux systems. After running it, ensure the resulting `cmake` binary is in your `$PATH`, so the Nvim build will find it.
      - Alternatively, you can directly install `cmake` to the `/usr/local` path:
      ```sh
      sudo ./cmake-<version>-linux-x86_64.sh --exclude-subdir --prefix=/usr/local
      ```

- Platform-specific requirements for Ubuntu / Debian are listed below:
  ```sh
  sudo apt-get install ninja-build gettext cmake curl build-essential
  ```

Please check [BUILD.md](https://github.com/neovim/neovim/blob/master/BUILD.md#build-prerequisites) to further ensure that the build prerequisites are correctly setup.
And refer to [INSTALL.md](https://github.com/neovim/neovim/blob/master/INSTALL.md) from Neovim website for more installation details.

**Build and Install Neovim**

```sh
git clone https://github.com/neovim/neovim ~/.config/nvim/neovim
cd ~/.config/nvim/neovim
git checkout stable # If you want the stable release
make CMAKE_BUILD_TYPE=RelWithDebInfo
# You can run the `nvim` executable before installing it by running `VIMRUNTIME=runtime ./build/bin/nvim`.
sudo make install
```

**Uninstall**

There is a CMake target to _uninstall_ after `make install`:

```sh
sudo cmake --build build/ --target uninstall
```

Alternatively, just delete the `CMAKE_INSTALL_PREFIX` artifacts, for Unix-like systems this is `/usr/local`:

```sh
sudo rm /usr/local/bin/nvim
sudo rm -r /usr/local/share/nvim/
```

**IMPORTANT**: Before upgrading Neovim to a new version, **always check for [Breaking Changes](https://neovim.io/doc/user/news.html#news-breaking).**

## 3.&nbsp;&nbsp; Install Neovim Plugins

**Setup Plugin Manager**

```sh
git clone https://github.com/junegunn/vim-plug ~/.config/nvim/bundle/vim-plug
```

**Update Plugins**

Launch `nvim` and run `:PlugInstall` (keymap: `<Ctrl-F9>`).

## 4.&nbsp;&nbsp; About Keymap Usage

Launch nvim and type `<Ctrl-F1>` to show keymap usage information.

## 5.&nbsp;&nbsp; Optional Installation

**Setup the optional tools environment**

```sh
# source "envsetup.sh" in ~/.bashrc as below:
if [ -f ~/.vim/optional-tools/envsetup.sh ]; then
    . ~/.vim/optional-tools/envsetup.sh
fi
```

**LSP client and Language Servers environment setup**

>*[What is the Language Server Protocol?](https://microsoft.github.io/language-server-protocol)*.

>LSP client and Language Servers check *[LSP implementations](https://langserver.org)*.

+ Setup the [Nodejs](https://nodejs.org/en/download/) environment if select [coc.nvim](https://github.com/neoclide/coc.nvim) as LSP client,  [coc.nvim](https://github.com/neoclide/coc.nvim) require [Nodejs](https://nodejs.org/en/download/) >= `10.12`, more information see the [coc.nvim](https://github.com/neoclide/coc.nvim).

```sh
git clone https://github.com/nodejs/node ~/.vim/nodejs
cd ~/.vim/nodejs
# use 'git branch -avv' find 'Current' branch as proposal
git checkout -b current remotes/origin/vxxxx
# check ~/.vim/nodejs/BUILDING.md
./configure && make -j4
sudo make install
node -v
```

Refer *[Nodejs Download](https://nodejs.org/en/download/)* for more installation ways.

After installing the Nodejs, Launch `nvim` and run `:PlugInstall` (keymap: `<Ctrl-F9>`).

