FROM centos:7

# General Deps
RUN yum -y groupinstall "Development Tools" && \
    yum -y install ca-certificates epel-release rpm-build squashfs-tools vim wget && \
    # relies on epel
    yum -y install jq && \

    # Compile newer version of sqlite3 \
    cd ~ && \
    wget -q https://www.sqlite.org/2021/sqlite-autoconf-3370000.tar.gz && \
    tar -xzf sqlite-autoconf-3370000.tar.gz && \
    cd sqlite-autoconf-3370000 && \
    ./configure --prefix=/usr && \
    make && \
    make install && \
    cd ~ && \
    rm -rf ~/sqlite-autoconf* && \
    yum clean all

# Compile newer version of python3
# CVE-2022-0778 fixed in openssl11-1.1.1k-3.el7 https://bugzilla.redhat.com/show_bug.cgi?id=2064913
RUN yum -y install openssl11 openssl11-devel bzip2-devel libffi-devel zlib-devel && \
    cd ~ && \
    wget -q https://www.python.org/ftp/python/3.9.9/Python-3.9.9.tgz && \
    tar xvf Python-3.9.9.tgz && \
    cd Python-3.9*/ && \
    # A bit hacky, but gets the proper/newer openssl 1.1.1 version into configure, instead of the default old openssl version \
    # https://stackoverflow.com/questions/69371800/how-to-link-python3-to-use-openssl11-or-latest-version-of-openssl-1-1-1-on-c
    sed -i 's/PKG_CONFIG openssl /PKG_CONFIG openssl11 /g' configure && \
    ./configure --enable-optimizations --prefix=/usr --enable-shared --enable-loadable-sqlite-extensions LDFLAGS="-Wl,-rpath /usr/lib" && \
    make install && \
    cd ~ && \
    rm -rf ~/Python-3.9* && \
    yum clean all

RUN pip3 install --upgrade pip && \
    pip3 install awscli

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
    yum clean all && \
    pip3 install --no-cache-dir py3createtorrent

# Add FPM
RUN gpg2 --keyserver keyserver.ubuntu.com --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB && \
    curl -sSL https://get.rvm.io | bash -s stable && \
    /bin/bash -l -c ". /etc/profile.d/rvm.sh && rvm install ruby-3 && gem install fpm" && \
    yum clean all
