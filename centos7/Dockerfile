FROM centos:7

ENV PYENV_ROOT=/root/.pyenv
ENV PATH="$PYENV_ROOT/shims:$PYENV_ROOT/bin:$PATH"

# General Deps
RUN yum -y groupinstall "Development Tools" && \
    yum -y install ca-certificates createrepo dnf epel-release rpm-build squashfs-tools vim wget && \
    # relies on epel
    yum -y install jq

# Compile newer version of sqlite3 \
RUN cd ~ && \
    wget -q https://sqlite.org/2022/sqlite-autoconf-3400100.tar.gz && \
    tar -xzf sqlite-autoconf-3400100.tar.gz && \
    cd sqlite-autoconf-3400100 && \
    ./configure --prefix=/usr && \
    make && \
    make install && \
    cd ~ && \
    rm -rf ~/sqlite-autoconf* && \
    yum clean all

# Compile newer version of python3
# CVE-2022-0778 fixed in openssl11-1.1.1k-3.el7 https://bugzilla.redhat.com/show_bug.cgi?id=2064913
RUN yum -y install openssl-devel openssl11 openssl11-devel zlib-devel bzip2 bzip2-devel readline-devel tk-devel libffi-devel xz-devel && \
    cd ~ && \
    # Set up pyenv \
    git clone https://github.com/pyenv/pyenv.git ~/.pyenv && \
    CPPFLAGS=$(pkg-config --cflags openssl11) LDFLAGS=$(pkg-config --libs openssl11) pyenv install 3.10 && \
    pyenv global 3.10 && \
    pip install --upgrade pip && \
    pip install --no-cache-dir py3createtorrent awscli && \
    yum clean all

# Add newer git version
RUN yum -y install curl-devel expat-devel gettext-devel perl-CPAN perl-devel zlib-devel && \
    cd ~ && \
    wget -q https://mirrors.edge.kernel.org/pub/software/scm/git/git-2.34.1.tar.gz && \
    tar xvf git-2.34.1.tar.gz && \
    cd git-2.34* && \
    make configure && \
    ./configure --prefix=/usr && \
    make all && \
    make install && \
    cd ~ && \
    rm -rf ~/git-2.34* && \
    yum clean all

# Add nodejs
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN curl -fsSL https://rpm.nodesource.com/setup_16.x | bash - && \
    yum install -y nodejs && \
    yum clean all

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
