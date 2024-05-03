#!/usr/bin/bash

cwd=$PWD

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
	LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
	curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
	tar xf lazygit.tar.gz lazygit
	sudo install lazygit /usr/local/bin
	git clone https://github.com/neovim/neovim
	cd neovim
	make CMAKE_BUILD_TYPE=Release
	sudo make install
	git clone https://github.com/JohnWick92/my-lazyvim ~/.config/nvim/
}

install_docker() {
	# Add Docker's official GPG key:
	sudo apt update
	sudo apt install -y ca-certificates curl
	sudo install -m 0755 -d /etc/apt/keyrings
	sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
	sudo chmod a+r /etc/apt/keyrings/docker.asc

	# Add the repository to Apt sources:
	echo \
		"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" |
		sudo tee /etc/apt/sources.list.d/docker.list >/dev/null
	sudo apt update
	sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
	sudo groupadd docker
	sudo usermod -aG docker $USER
	# newgrp docker
	sudo systemctl enable --now docker
}

install_flatpaks() {
	sudo apt install -y flatpak
	sudo apt install -y gnome-software-plugin-flatpak
	flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
	flatpak install -y flathub com.bitwarden.desktop
	flatpak install -y flathub app.ytmdesktop.ytmdesktop
}

install_wezterm() {
	curl -fsSL https://apt.fury.io/wez/gpg.key | sudo gpg --yes --dearmor -o /usr/share/keyrings/wezterm-fury.gpg
	echo 'deb [signed-by=/usr/share/keyrings/wezterm-fury.gpg] https://apt.fury.io/wez/ * *' | sudo tee /etc/apt/sources.list.d/wezterm.list
	sudo apt update && sudo apt install -y wezterm
	mkdir ~/.config/wezterm
	echo 'local wezterm = require("wezterm")
    local act = wezterm.action
    local config = {}
    if wezterm.config_builder then config = wezterm.config_builder() end

    config.color_scheme = "Tokyo Night"
    config.font = wezterm.font_with_fallback({
        { family = "IosevkaTerm Nerd Font", scale = 1.2}
    })
    config.window_background_opacity = 0.9
    config.leader = {key = "a", mods = "CTRL", timeout_milliseconds = 1000}
    config.keys = {
        {key = "a", mods = "LEADER | CTRL", action = act.SendKey { key = "a", mods = "CTRL"}},
        { key = "s", mods = "LEADER", action = act.SplitVertical { domain = "CurrentPaneDomain" } },
        { key = "v", mods = "LEADER", action = act.SplitHorizontal { domain = "CurrentPaneDomain" } },
        {key = "h", mods = "LEADER", action = act.ActivatePaneDirection("Left")},
        {key = "j", mods = "LEADER", action = act.ActivatePaneDirection("Down")},
        {key = "k", mods = "LEADER", action = act.ActivatePaneDirection("Up")},
        {key = "l", mods = "LEADER", action = act.ActivatePaneDirection("Right")},
        { key = "q", mods = "LEADER", action = act.CloseCurrentPane { confirm = false } },
        {key = "t", mods = "LEADER", action = act.SpawnTab "CurrentPaneDomain"},
    }
    -- Uncomment this if you are running in wsl
    -- config.default_domain = "WSL:Ubuntu"
    return config' >~/.config/wezterm/wezterm.lua
}

install_iosevka() {
	cd /tmp
	wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/IosevkaTerm.zip
	unzip Iosevka.zip
	sudo mkdir /usr/share/fonts/iosevka
	sudo mv *.ttf /usr/share/fonts/iosevka
}

last_things() {
	echo "To export path to fish enter in fish shell and run this commands:"
	echo "fish_add_path ~/.local/bin"
	echo "To fish be your default shell you need to reboot the machine"
	echo "Open neovim wait until it download the plugins close and run it again"
	echo "See the git-delta to set up delta to your git config"
	echo "That's all thanks for using this script :)"
	echo "Type your password to confirm fish as your default shell then reboot the machine"
	chsh -s /usr/bin/fish
}

check_root
fetch_updates
install_base_dev
install_rust_alternatives
install_starship
install_wezterm
install_lazyvim
install_flatpaks
install_docker
install_iosevka
install_asdf
cd "$cwd"
./debian-based-fish.sh
last_things
