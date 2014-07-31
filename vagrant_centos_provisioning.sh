#!/usr/bin/env bash

# override PS1 prompt
echo 'export PS1="\w \$ "' >> ~/.bashrc

# tmux installation instructions from here
# https://gist.github.com/rschuman/6168833

sudo su -

yum -y install gcc kernel-devel make ncurses-devel
yum -y install git-core expect vim ruby ruby-devel ruby-irb

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
