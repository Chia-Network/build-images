FROM centos:7

# General Deps
RUN yum -y groupinstall "Development Tools" && \
    yum -y install vim wget awscli epel-release && \
    yum -y install jq # relies on epel

# Compile newer version of python3
RUN yum -y install openssl-devel bzip2-devel libffi-devel sqlite-devel && \
    cd ~ && \
    wget https://www.python.org/ftp/python/3.9.6/Python-3.9.6.tgz && \
    tar xvf Python-3.9.6.tgz && \
    cd Python-3.9*/ && \
    ./configure --enable-optimizations --prefix=/usr --enable-shared --enable-loadable-sqlite-extensions LDFLAGS="-Wl,-rpath /usr/lib" && \
    make install && \
    cd ~ && \
    rm -rf ~/Python-3.9*

# Compile newer version of git (actions runner needs it)
RUN yum -y install curl-devel expat-devel gettext-devel openssl-devel zlib-devel perl-CPAN perl-devel && \
    cd ~ && \
    wget https://mirrors.edge.kernel.org/pub/software/scm/git/git-2.32.0.tar.gz && \
    tar xvf git-2.32.0.tar.gz && \
    cd git-2.32* && \
    make configure && \
    ./configure --prefix=/usr && \
    make all && \
    make install && \
    cd ~ && \
    rm -rf ~/git-2.32*

# Add nodejs
RUN curl -sL https://rpm.nodesource.com/setup_14.x | bash - && \
    yum install -y nodejs

RUN pip3 install py3createtorrent
