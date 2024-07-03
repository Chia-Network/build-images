FROM quay.io/pypa/manylinux_2_28_x86_64

ENV PATH=/usr/local/cuda-12.5/bin${PATH:+:${PATH}}

RUN dnf config-manager --add-repo https://developer.download.nvidia.com/compute/cuda/repos/rhel8/x86_64/cuda-rhel8.repo && \
    dnf -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm && \
    dnf clean all && \
    dnf -y module install nvidia-driver:latest-dkms && \
    dnf -y install cuda-toolkit
