#!/usr/bin/bash

check_root() {
	if [ "$EUID" -eq 0 ]; then
		echo "Please do not run as root"
		exit
	fi
}

fetch_updates() {
	sudo dnf upgrade -y && sudo dnf autoremove -y
}

install_base_dev() {
	sudo dnf -y install ninja-build cmake gcc make unzip gettext curl glibc-gconv-extra git fish
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

install_docker() {
	sudo dnf remove docker \
		docker-client \
		docker-client-latest \
		docker-common \
		docker-latest \
		docker-latest-logrotate \
		docker-logrotate \
		docker-selinux \
		docker-engine-selinux \
		docker-engine
	sudo dnf -y install dnf-plugins-core
	sudo dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
	sudo dnf install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
	sudo groupadd docker
	sudo usermod -aG docker $USER
	newgrp docker
	sudo systemctl enable --now docker
}

install_alacritty() {
	sudo dnf install -y cmake freetype-devel fontconfig-devel libxcb-devel libxkbcommon-devel xcb-util-devel
	sudo dnf group install "Development Tools"
	cd /tmp && git clone https://github.com/alacritty/alacritty.git && cd alacritty
	cargo build --release
	sudo tic -xe alacritty,alacritty-direct extra/alacritty.info
	sudo cp target/release/alacritty /usr/local/bin # or anywhere else in $PATH
	sudo cp extra/logo/alacritty-term.svg /usr/share/pixmaps/Alacritty.svg
	sudo desktop-file-install extra/linux/Alacritty.desktop
	sudo update-desktop-database
	mkdir -p $fish_complete_path[1]
	cp extra/completions/alacritty.fish $fish_complete_path[1]/alacritty.fish
}

install_flatpaks() {
	flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
	flatpak install flathub com.bitwarden.desktop
	flatpak install flathub app.ytmdesktop.ytmdesktop
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
./rhel-based-fish.sh
install_rust_alternatives
install_starship
install_lazyvim
install_alacritty
install_flatpaks
install_docker
last_things