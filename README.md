# lidarT
LiDAR using ROS 2.

## Setup
1. Install NVIDIA Container Toolkit (this can get tricky sometimes):
   ```
    curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg
    curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list | \
      sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | \
      sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list
    sudo apt-get update
    sudo apt-get install -y nvidia-container-toolkit
   ```
3. Clone repository
 ```
git clone https://github.com/tubyornottuby/lidarT
cd lidarT
 ```
4. Build the container
```
docker build -t ros2-ubuntu22.04
```
5. Start development environment
```
docker run -it --rm ros2-ubuntu22.04
```
