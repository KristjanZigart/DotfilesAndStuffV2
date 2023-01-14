#!/usr/bin/env bash

. ./helper_functions.sh
check_distro
check_programs_path

# Common

# Install tmux plugin manager and install all plugins, this file should kept
# out of git.
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
bash ~/.tmux/plugins/tpm/scripts/install_plugins.sh

# Not related to development, but it makes life easier when learning new commands
pip install tldr

# Neovim tooling - linters, formatters
pip install pynvim
pip install neovim

# Bash formatter, this will need latest golang on Ubuntu
go install mvdan.cc/sh/v3/cmd/shfmt@latest

# Lua formatter and linter
cargo install stylua
sudo luarocks install luacheck

# Python formatter, linter and lsp server
pip install black
pip install flake8
pip install pyright

# Cmake formatter
pip install cmakelang

# Json formatter
sudo npm install -g fixjson

# Tree sitter
cargo install tree-sitter-cli

# Fix for stupid markdown preview plugin thing
sudo npm install -g tslib
sudo npm install -g yarn
sudo yarn add tslib

# Vale for linting markdown files
mkdir vale
wget https://github.com/errata-ai/vale/releases/download/v2.15.2/vale_2.15.2_Linux_64-bit.tar.gz
tar xf vale_2.15.2_Linux_64-bit.tar.gz -C vale
sudo mv vale/vale /usr/bin
rm -fr vale
rm -fr vale_2.15.2_Linux_64-bit.tar.gz

# Hadolint for linting docker files
wget https://github.com/hadolint/hadolint/releases/download/v2.10.0/hadolint-Linux-x86_64
sudo chmod +x hadolint-Linux-x86_64
sudo mv hadolint-Linux-x86_64 /usr/local/bin/hadolint

if [ "$DISTRO" = "MANJARO" ]; then
	# Manjaro specific
	install neovim ctags ripgrep fd clang
	installyay diff-so-fancy
else
	# Ubuntu specific
	# Install dependencies common to all packages
	sudo add-apt-repository ppa:aos1/diff-so-fancy
	sudo apt-get update
	install diff-so-fancy ninja-build gettext libtool libtool-bin doxygen pkg-config autoconf automake

	# Install Neovim
	cd $PROGRAMS_PATH
	git clone https://github.com/neovim/neovim
	cd neovim && make
	git checkout stable
	make -j16 CMAKE_BUILD_TYPE=RelWithDebInfo # Could also be set to Release
	sudo make install

	# Install Ctags
	cd $PROGRAMS_PATH
	git clone https://github.com/universal-ctags/ctags.git
	cd ctags
	./autogen.sh
	./configure #--prefix=/where/you/want # defaults to /usr/local
	make -j16
	sudo make install # may require extra privileges depending on where to install
	cd ..
	rm -fr ctags

	cd $PROGRAMS_PATH
	# Rip grep
	curl -LO https://github.com/BurntSushi/ripgrep/releases/download/13.0.0/ripgrep_13.0.0_amd64.deb
	sudo dpkg -i ripgrep_13.0.0_amd64.deb
	rm ripgrep_13.0.0_amd64.deb

	# Fd
	wget https://github.com/sharkdp/fd/releases/download/v8.3.1/fd_8.3.1_amd64.deb
	sudo dpkg -i fd_8.3.1_amd64.deb
	rm fd_8.3.1_amd64.deb

	# Clangformat, there was no way to just get it alone without whole
	# clang tooling, plus I had to do symlinks. Not so happy about this.
	wget https://apt.llvm.org/llvm.sh
	chmod +x llvm.sh
	sudo ./llvm.sh 15 all # Install all packages, version 14
	rm llvm.sh
fi
