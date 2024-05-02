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
}

install_rust_alternatives() {
	curl --proto '=https' --tlsv1.2 https://sh.rustup.rs -sSf | sh
	source ~/.cargo/env
	cargo install ripgrep zoxide fd-find tealdeer procs git-delta bat exa du-dust tokei ytop rmesg grex
	echo "zoxide init fish | source" >>~/.config/fish/config.fish
}

install_asdf() {
	git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.14.0
	echo 'source ~/.asdf/asdf.fish' | cat - ~/.config/fish/config.fish >temp && mv temp ~/.config/fish/config.fish
}

install_starship() {
	curl -sS https://starship.rs/install.sh | sh
	echo "starship init fish | source" >>~/.config/fish/config.fish
}

install_lazyvim() {
	cd /tmp/
	git clone https://github.com/neovim/neovim
	cd neovim
	make CMAKE_BUILD_TYPE=Release
	sudo make install
	git clone https://github.com/JohnWick92/my-lazyvim ~/.config/nvim/
}

install_meslo() {
	cd /tmp
	wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/Meslo.zip
	unzip Meslo.zip
	mkdir /usr/share/fonts/meslo
	sudo mv *.ttf /usr/share/fonts/meslo
}

last_things() {
	echo "To export path to fish enter in fish shell and run this commands:"
	echo "To fish be your default shell you need to reboot the machine"
	echo "Open neovim wait until it download the plugins close and run it again"
	echo "See the git-delta to set up delta to your git config"
	echo "That's all thanks for using this script :)"
	echo "Type your password to confirm fish as your default shell then reboot the wsl"
	chsh -s /usr/bin/fish
}

check_root
fetch_updates
install_base_dev
install_rust_alternatives
install_starship
install_lazyvim
install_asdf
./ubuntu-wsl-fish.sh
last_things
