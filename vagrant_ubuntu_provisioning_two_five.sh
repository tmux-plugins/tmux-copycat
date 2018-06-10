#!/usr/bin/env bash

# override PS1 prompt
echo 'export PS1="\$ "' >> /home/vagrant/.bashrc
# simplify irb prompt
echo 'IRB.conf[:PROMPT_MODE] = :SIMPLE' >> /home/vagrant/.irbrc
chown -R vagrant:vagrant /home/vagrant/.irbrc

sudo apt-get update
sudo apt-get install -y make
sudo apt-get install -y git-core expect vim gawk
sudo apt-get install -y python-software-properties software-properties-common

# install Tmux 2.5
VERSION=2.5
sudo apt-get -y remove tmux
sudo apt-get -y install wget tar libevent-dev libncurses-dev
wget https://github.com/tmux/tmux/releases/download/${VERSION}/tmux-${VERSION}.tar.gz
tar xf tmux-${VERSION}.tar.gz
rm -f tmux-${VERSION}.tar.gz
cd tmux-${VERSION}
./configure
make
sudo make install
cd -
sudo rm -rf /usr/local/src/tmux-*
sudo mv tmux-${VERSION} /usr/local/src

# clone a repo used later for tests
git clone https://github.com/tmux-plugins/tmux-example-plugin /home/vagrant/tmux-example-plugin
chown -R vagrant:vagrant /home/vagrant/tmux-example-plugin

sudo locale-gen "en_US.UTF-8"
sudo update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
