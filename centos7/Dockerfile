FROM centos:7

# General Deps
RUN yum -y groupinstall "Development Tools" && \
    yum -y install awscli ca-certificates epel-release vim wget && \
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

    # Compile Openssl
RUN yum -y install zlib-devel && \
    wget https://www.openssl.org/source/openssl-1.1.1n.tar.gz && \
    tar -zxvf openssl-1.1.1n.tar.gz && \
    cd openssl-1.1.1n && \
    ./config --prefix=/usr --openssldir=/etc/ssl --libdir=lib no-shared zlib-dynamic && \
    make install && \
    rm -rf ~/openssl* && \
    yum clean all

    # Compile newer version of python3
RUN yum -y install bzip2-devel libffi-devel && \
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

    # Compile newer version of git (actions runner needs it)
RUN yum -y install https://packages.endpointdev.com/rhel/7/os/x86_64/endpoint-repo.x86_64.rpm && \
    yum install -y git && \
    yum clean all

#RUN yum -y install curl-devel expat-devel gettext-devel perl-CPAN perl-devel zlib-devel && \
#    cd ~ && \
#    wget -q https://mirrors.edge.kernel.org/pub/software/scm/git/git-2.34.1.tar.gz && \
#    tar xvf git-2.34.1.tar.gz && \
#    cd git-2.34* && \
#    make configure && \
#    ./configure --prefix=/usr && \
#    make all && \
#    make install && \
#    cd ~ && \
#    rm -rf ~/git-2.34* && \
#    yum clean all

# Add nodejs
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN curl -fsSL https://rpm.nodesource.com/setup_16.x | bash - && \
    yum install -y nodejs && \
    yum clean all && \
    pip3 install --no-cache-dir py3createtorrent
