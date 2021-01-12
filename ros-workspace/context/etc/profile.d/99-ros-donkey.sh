# Always source the appropriate ROS2 setup file ... gives access to 'ros2'
if [[ -r /opt/ros/${ROS_DISTRO}/setup.bash ]]; then
  . /opt/ros/${ROS_DISTRO}/setup.bash
fi

# Source the application-specific setup script, if available:
# Valid in 'production' mode
if [[ -r /opt/ros-donkey/install/setup.bash ]]; then
  . /opt/ros-donkey/install/setup.bash
fi

# Valid in 'development' mode
if [[ -r /home/ros-donkey/workspace/install/setup.bash ]]; then
  . /home/ros-donkey/workspace/install/setup.bash
fi