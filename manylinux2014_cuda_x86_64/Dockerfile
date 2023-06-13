FROM quay.io/pypa/manylinux2014_x86_64

RUN yum-config-manager --add-repo https://developer.download.nvidia.com/compute/cuda/repos/rhel7/x86_64/cuda-rhel7.repo && \
    yum clean all && \
    yum -y install nvidia-driver-latest-dkms && \
    yum -y install cuda
