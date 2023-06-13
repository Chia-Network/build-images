FROM quay.io/pypa/manylinux2014_aarch64

RUN export module_platform_id=platform:el9 && \
    export MODULE_PLATFORM_ID=platform:el9 && \
    export PLATFORM_ID=platform:el9 && \
    yum install -y dnf && \
    dnf install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm && \
    dnf install -y dnf-plugins-core && \
    dnf makecache && \
    dnf install -y kernel-headers.aarch64 kernel-devel.aarch64 && \
    dnf config-manager --add-repo http://developer.download.nvidia.com/compute/cuda/repos/rhel9/aarch64/cuda-rhel9.repo && \
    dnf config-manager --add-repo http://developer.download.nvidia.com/compute/cuda/repos/rhel9/sbsa/cuda-rhel9.repo && \
    dnf makecache && \
    dnf install -y cuda-toolkit

ENV PATH=/usr/local/cuda-12.1/bin${PATH:+:${PATH}}
