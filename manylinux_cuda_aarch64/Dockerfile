FROM quay.io/pypa/manylinux_2_34_aarch64

ENV PATH=/usr/local/cuda-12.8/bin${PATH:+:${PATH}}

RUN dnf -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm && \
    dnf install -y kernel-headers.aarch64 kernel-devel.aarch64 && \
    dnf config-manager --add-repo http://developer.download.nvidia.com/compute/cuda/repos/rhel9/aarch64/cuda-rhel9.repo && \
    dnf config-manager --add-repo http://developer.download.nvidia.com/compute/cuda/repos/rhel9/sbsa/cuda-rhel9.repo && \
    dnf clean all && \
    dnf install -y cuda-toolkit
