# Use the official Ubuntu 22.04 image as a base
FROM ubuntu:22.04

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV ROS_DISTRO=humble
ENV LANG=C.UTF-8
ENV LC_ALL=C.UTF-8

# Update and install basic dependencies
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

# Install ROS 2 and additional tools
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

# Create a workspace directory
WORKDIR /root/ros2_ws

# Default command to keep the container running
CMD ["bash"]
