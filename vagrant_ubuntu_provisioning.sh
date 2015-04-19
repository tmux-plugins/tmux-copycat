#!/usr/bin/env bash

# override PS1 prompt
echo 'export PS1="\$ "' >> /home/vagrant/.bashrc
# simplify irb prompt
echo 'IRB.conf[:PROMPT_MODE] = :SIMPLE' >> /home/vagrant/.irbrc
chown -R vagrant:vagrant /home/vagrant/.irbrc

sudo apt-get update
sudo apt-get install -y git-core expect vim gawk
sudo apt-get install -y python-software-properties software-properties-common

# install latest Tmux 1.9a
sudo add-apt-repository -y ppa:pi-rho/dev
sudo apt-get update
sudo apt-get install -y tmux=1.9a-1~ppa1~p

# clone a repo used later for tests
git clone https://github.com/tmux-plugins/tmux-example-plugin /home/vagrant/tmux-example-plugin
chown -R vagrant:vagrant /home/vagrant/tmux-example-plugin
