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
    python3-colcon-common-extensions \
    python3-pip \
    python3-rosdep \
    python3-vcstool \
    wget && \
    rm -rf /var/lib/apt/lists/*

# Add the ROS 2 apt repository
RUN curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key | apt-key add - && \
    echo "deb [arch=amd64,arm64] http://packages.ros.org/ros2/ubuntu $(lsb_release -cs) main" > /etc/apt/sources.list.d/ros2.list

# Install ROS 2
RUN apt-get update && apt-get install -y --no-install-recommends \
    ros-${humble}-desktop && \
    rm -rf /var/lib/apt/lists/*

# Initialize rosdep
RUN rosdep init && rosdep update

# Setup the ROS 2 environment
RUN echo "source /opt/ros/$ROS_DISTRO/setup.bash" >> /etc/bash.bashrc
SHELL ["/bin/bash", "-c"]

# Create a workspace directory
WORKDIR /root/ros2_ws

# Add runtime library path to ensure libraries can be found
ENV LD_LIBRARY_PATH=/usr/lib/x86_64-linux-gnu:${LD_LIBRARY_PATH}

# Default command to keep the container running
CMD ["bash"]
