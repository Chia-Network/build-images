FROM quay.io/pypa/manylinux_2_28_aarch64

ENV PATH=/usr/local/cuda/bin${PATH:+:${PATH}}

RUN dnf update -y && \
    dnf install -y epel-release && \
    dnf install -y kernel-headers.aarch64 kernel-devel.aarch64 && \
    dnf config-manager --add-repo http://developer.download.nvidia.com/compute/cuda/repos/rhel8/aarch64/cuda-rhel8.repo && \
    dnf config-manager --add-repo http://developer.download.nvidia.com/compute/cuda/repos/rhel8/sbsa/cuda-rhel8.repo && \
    dnf clean all && \
    dnf install -y cuda-toolkit
