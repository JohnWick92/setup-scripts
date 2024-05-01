#!/usr/bin/bash

check_root() {
	if [ "$EUID" -eq 0 ]; then
		echo "Please do not run as root"
		exit
	fi
}

fetch_updates() {
	sudo apt update && sudo apt full-upgrade -y && sudo apt autoremove -y
}

install_base_dev() {
	sudo apt install -y curl git ninja-build gettext cmake unzip build-essential fish
	chsh -s /usr/bin/fish
}

install_rust_alternatives() {
	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
	cargo install ripgrep zoxide fd-find tealdeer procs git-delta bat exa du-dust tokei ytop rmesg grex
	echo "zoxide init fish | source" >>~/.config/fish/config.fish
}

install_asdf() {
	git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.14.0
	sed '1 s/^/source ~/.asdf/asdf.fish\n/' ~/.config/fish/config.fish
	mkdir -p ~/.config/fish/completions
	and ln -s ~/.asdf/completions/asdf.fish ~/.config/fish/completions
}

install_starship() {
	curl -sS https://starship.rs/install.sh | sh
	echo "starship init fish | source" >>~/.config/fish/config.fish
}

install_lazyvim() {
	cd /tmp/
	git clone https://github.com/neovim/neovim && cd neovim
	make CMAKE_BUILD_TYPE=Release
	make install
	git clone https://github.com/JohnWick92/my-lazyvim ~/.config/nvim/
}

last_things() {
	echo "To export path to fish enter in fish shell and run this commands:"
	echo "fish_add_path ~/.local/bin"
	echo "fish_add_path ~/.cargo/bin"
	echo "To fish be your default shell you need to reboot the machine"
	echo "Open neovim wait until it download the plugins close and run it again"
	echo "See the git-delta to set up delta to your git config"
	echo "That's all thanks for using this script :)"
}

check_root
fetch_updates
install_base_dev
install_asdf
./ubuntu-wsl-fish.sh
install_rust_alternatives
install_starship
install_lazyvim
last_things
