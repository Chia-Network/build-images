FROM rockylinux:8

ENV PYENV_ROOT=/root/.pyenv
ENV PATH="$PYENV_ROOT/shims:$PYENV_ROOT/bin:$PATH"
# Python needs to be able to find the proper sqlite3 install
ENV CPPFLAGS="-I/usr/sqlite3/include"
ENV LIBRARY_PATH="/usr/sqlite3/lib"
ENV LD_LIBRARY_PATH="/usr/sqlite3/lib"
ENV NVM_DIR="/root/.nvm"

# General Deps
RUN yum -y groupinstall "Development Tools" && \
    yum -y install ca-certificates createrepo dnf epel-release git procps rpm-build squashfs-tools vim wget && \
    # jq relies on epel
    yum -y install jq && \
    yum clean all

# Compile newer version of sqlite3
RUN cd ~ && \
    wget -q https://www.sqlite.org/2024/sqlite-autoconf-3450100.tar.gz && \
    tar -xzf sqlite-autoconf-3450100.tar.gz && \
    cd sqlite-autoconf-3450100 && \
    CFLAGS="-DSQLITE_MAX_VARIABLE_NUMBER=500000" ./configure --prefix=/usr/sqlite3 && \
    make && \
    make install && \
    cd ~ && \
    rm -rf ~/sqlite-autoconf*

# Compile newer version of python3
RUN yum -y install openssl openssl-devel zlib-devel bzip2 bzip2-devel readline-devel tk-devel libffi-devel xz-devel && \
    cd ~ && \
    # Set up pyenv \
    git clone https://github.com/pyenv/pyenv.git ~/.pyenv && \
    pyenv install 3.11 && \
    pyenv global 3.11 && \
    pip install --upgrade pip && \
    pip install --no-cache-dir py3createtorrent awscli && \
    python3 -c 'import sys; import sqlite3; sys.exit(sqlite3.sqlite_version != "3.45.1")' && \
    yum clean all

# Add nodejs
RUN git clone https://github.com/nvm-sh/nvm.git "$NVM_DIR" && \
    cd "$NVM_DIR" && \
    git checkout `git describe --abbrev=0 --tags --match "v[0-9]*" $(git rev-list --tags --max-count=1)` && \
    \. "$NVM_DIR/nvm.sh" && \
    nvm install 18 && \
    nvm alias default 18 && \
    for nodebin in $NVM_DIR/versions/node/$(nvm current)/bin/*; do ln -s "$nodebin" /usr/bin/$(basename $nodebin); done

# Add FPM
RUN gpg2 --keyserver keyserver.ubuntu.com --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB && \
    curl -sSL https://get.rvm.io | bash -s stable && \
    /bin/bash -l -c ". /etc/profile.d/rvm.sh && rvm install ruby-3 && gem install fpm" && \
    yum clean all

# Add GitHub CLI
RUN dnf -y update && \
    dnf -y install 'dnf-command(config-manager)' && \
    dnf -y config-manager --add-repo https://cli.github.com/packages/rpm/gh-cli.repo && \
    dnf -y install gh
