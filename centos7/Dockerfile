FROM centos:7

# General Deps
RUN yum -y groupinstall "Development Tools" && \
    yum -y install vim wget awscli epel-release && \
    # relies on epel
    yum -y install jq && \

    # Compile newer version of python3
    yum -y install openssl-devel bzip2-devel libffi-devel sqlite-devel && \
    cd ~ && \
    wget -q https://www.python.org/ftp/python/3.9.6/Python-3.9.6.tgz && \
    tar xvf Python-3.9.6.tgz && \
    cd Python-3.9*/ && \
    ./configure --enable-optimizations --prefix=/usr --enable-shared --enable-loadable-sqlite-extensions LDFLAGS="-Wl,-rpath /usr/lib" && \
    make install && \
    cd ~ && \
    rm -rf ~/Python-3.9* && \

    # Compile newer version of git (actions runner needs it)
    yum -y install ca-certificates curl-devel expat-devel gettext-devel openssl-devel zlib-devel perl-CPAN perl-devel && \
    cd ~ && \
    wget -q https://mirrors.edge.kernel.org/pub/software/scm/git/git-2.32.0.tar.gz && \
    tar xvf git-2.32.0.tar.gz && \
    cd git-2.32* && \
    make configure && \
    ./configure --prefix=/usr && \
    make all && \
    make install && \
    cd ~ && \
    rm -rf ~/git-2.32* && \
    yum clean all

# Add nodejs
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN curl -fsSL https://rpm.nodesource.com/setup_16.x | bash - && \
    yum install -y nodejs && \
    yum clean all && \
    pip3 install --no-cache-dir py3createtorrent
