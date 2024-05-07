#!/usr/bin/fish

function install_base_languages -d "install base languages"
fish_add_path ~/.cargo/bin/
echo 'source ~/.asdf/asdf.fish' | cat - ~/.config/fish/config.fish >temp && mv temp ~/.config/fish/config.fish
source ~/.config/fish/config.fish
asdf plugin add ruby
asdf plugin add java
asdf plugin add nodejs
asdf plugin add golang
sudo apt install -y autoconf patch libssl-dev libyaml-dev libreadline6-dev zlib1g-dev libgmp-dev libncurses5-dev libffi-dev libgdbm6 libgdbm-dev libdb-dev uuid-dev
asdf install ruby 3.2.3 && asdf global ruby 3.2.3
asdf install java openjdk-17 && asdf global java openjdk-17
asdf install nodejs latest && asdf global nodejs latest
asdf install golang latest && asdf global golang latest
npm i -g yarn
end

install_base_languages
mkdir -p ~/.config/fish/completionss
podman completion -f ~/.config/fish/
and ln -s ~/.asdf/completions/asdf.fish ~/.config/fish/completioncompletions/podman.fish fish
