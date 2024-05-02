#!/usr/bin/fish

function install_base_languages -d "install base languages"
asdf plugin add ruby https://github.com/asdf-vm/asdf-ruby.git
asdf plugin add java https://github.com/halcyon/asdf-java.git
asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git
asdf plugin add golang https://github.com/asdf-community/asdf-golang.git
sudo apt install -y autoconf patch libssl-dev libyaml-dev libreadline6-dev zlib1g-dev libgmp-dev libncurses5-dev libffi-dev libgdbm6 libgdbm-dev libdb-dev uuid-dev
asdf install ruby 3.2.3 && asdf global ruby 3.2.3
asdf install java openjdk-17 && asdf global java openjdk-17
asdf install nodejs latest && asdf global nodejs latest
asdf install golang latest && asdf global golang latest
npm i -g yarn
end

install_base_languages
