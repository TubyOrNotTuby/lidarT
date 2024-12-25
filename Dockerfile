# Start with Ubuntu 22.04
FROM ubuntu:22.04

# Set up environment variables for better reproducibility and convenience
# DEBIAN_FRONTEND prevents interactive prompts during package installation
# NVIDIA_VISIBLE_DEVICES ensures GPU access
# CUDA paths help tools find CUDA installations
ENV DEBIAN_FRONTEND=noninteractive
ENV ROS_DISTRO=humble
ENV LANG=C.UTF-8
ENV LC_ALL=C.UTF-8

# Install dependencies needed for building ROS
# We group these installations to minimize Docker layers and cleanup apt cache
# to reduce image size
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    gnupg2 \
    lsb-release \
    build-essential \
    cmake \
    git \
    python3-pip \
    wget && \
    rm -rf /var/lib/apt/lists/*

# Add the ROS 2 apt repository
RUN curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key | apt-key add - && \
    echo "deb [arch=amd64] http://packages.ros.org/ros2/ubuntu $(lsb_release -cs) main" > /etc/apt/sources.list.d/ros2.list && \
    apt-get update

# Install ROS 2 and additional tools after ROS 2 apt repo is added
# Probably could combine these in some way unsure
RUN apt-get install -y --no-install-recommends \
    ros-${ROS_DISTRO}-desktop \
    python3-colcon-common-extensions \
    python3-rosdep \
    python3-vcstool && \
    rm -rf /var/lib/apt/lists/*

# Initialize rosdep
RUN rosdep init && rosdep update

# Setup the ROS 2 environment
RUN echo "source /opt/ros/$ROS_DISTRO/setup.bash" >> /etc/bash.bashrc
SHELL ["/bin/bash", "-c"]

# Set up the build directory
WORKDIR /root/ros2_ws

# Default command to keep the container running
CMD ["bash"]
