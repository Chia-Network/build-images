FROM quay.io/pypa/manylinux_2_34_x86_64

ENV PATH=/usr/local/cuda/bin${PATH:+:${PATH}}

RUN dnf config-manager --add-repo https://developer.download.nvidia.com/compute/cuda/repos/rhel9/x86_64/cuda-rhel9.repo && \
    dnf install -y epel-release && \
    dnf clean expire-cache && \
    dnf module enable -y nvidia-driver:560-open && \
    dnf install -y cuda
