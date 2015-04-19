#!/usr/bin/env bash

# override PS1 prompt
echo 'export PS1="\$ "' >> ~/.bashrc
# simplify irb prompt
echo 'IRB.conf[:PROMPT_MODE] = :SIMPLE' >> /home/vagrant/.irbrc
chown -R vagrant:vagrant /home/vagrant/.irbrc

# tmux installation instructions from here
# https://gist.github.com/rschuman/6168833

sudo su -

yum -y install gcc kernel-devel make ncurses-devel
yum -y install git-core expect vim gawk ruby ruby-devel ruby-irb

# download tmux and libevent
mkdir ~/downloads && cd ~/downloads
curl http://sourceforge.net/projects/levent/files/latest/download?source=files -L -o libevent2.tar.gz -w 'Last URL was: %{url_effective}'
curl http://sourceforge.net/projects/tmux/files/latest/download?source=files -L -o tmux.tar.gz -w 'Last URL was: %{url_effective}'

# compile libevent
cd ~/downloads
tar zxvf libevent2.tar.gz
cd libevent-*-stable
./configure --prefix=/usr/local
make
make install

# compile tmux
cd ~/downloads
tar zxvf tmux.tar.gz
cd tmux-*
LDFLAGS="-L/usr/local/lib -Wl,-rpath=/usr/local/lib" ./configure --prefix=/usr/local
make
make install

# clone a repo used later for tests
git clone https://github.com/tmux-plugins/tmux-example-plugin /home/vagrant/tmux-example-plugin
chown -R vagrant:vagrant /home/vagrant/tmux-example-plugin
