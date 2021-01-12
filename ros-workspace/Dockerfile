# ============================================================================
FROM ros:foxy-ros-base-focal AS base
# ============================================================================

# Enable udevd so that plugged dynamic hardware devices show up in our container.
ENV UDEV=1

# Defaults for this application
ENV ROS_USER=ros-donkey
ENV WORKSPACE=/home/${ROS_USER}/workspace

COPY context/   /
# Fix permissions
# Copying the context from a Windows mount wreaks havoc :(
RUN chmod a+rX /etc

RUN ln -sf /usr/share/zoneinfo/America/Denver   /etc/localtime  &&  \
    apt-get update                                              &&  \
    apt-get install -y  less                                        \
                        libi2c-dev                                  \
                        i2c-tools                                   \
                        python3-numpy                               \
                        python3-pip                                 \
                        python3-smbus                               \
                        tzdata                                  &&  \
    pip3  install blessed                                           \
                  RPLCD

# Vision-stuff
#- RUN apt-get install -y  libatlas3-base                              \
#-                         libatlas-base-dev                           \
#-                         libavcodec-dev                              \
#-                         libavdevice-dev                             \
#-                         libavfilter-dev                             \
#-                         libavformat-dev                             \
#-                         libopencv-dev                               \
#-                         libopus-dev                                 \
#-                         libsrtp2-dev                                \
#-                         libswscale-dev                              \
#-                         libv4l-0                                    \
#-                         libv4lconvert0                              \
#-                         libvpx-dev                                  \
#-                         python3-opencv                              \
#-                         uvcdynctrl                                  \
#-                         v4l-conf                                    \
#-                         v4l-utils                                   \
#-                         v4l2loopback-utils
  
  
# - Replace /usr/local/include with the ROS directory (a specialization for
#   Eclipse to find and index include files)
#
# - Execute our Docker build scripts
#
# - Create the ros-donkey user
RUN rmdir /usr/local/include                                      &&  \
    ln -sf /opt/ros/foxy/include    /usr/local/include            &&  \
    useradd --create-home  --shell /bin/bash  ${ROS_USER}


# ============================================================================
FROM base AS builder
# ============================================================================

# Copy the source code in preparation for building... again, windows
# wreaks havoc with permissions...
COPY src/ ${WORKSPACE}/src
RUN chown -R ${ROS_USER}:${ROS_USER}  ${WORKSPACE}                &&  \
    chmod -R a+rX                     ${WORKSPACE}

# Set the default user and default workspace
USER ${ROS_USER}
WORKDIR ${WORKSPACE}

# Use bash (vice /bin/sh) to source the setup and build the code
SHELL ["/bin/bash", "-c"]
RUN source /opt/ros/${ROS_DISTRO}/setup.bash                &&  \
    colcon build


# ============================================================================
FROM base AS runner
# ============================================================================

USER root
COPY --from=builder ${WORKSPACE}/install /opt/${ROS_USER}/install

# Insert our 'source' command before the last line of the default ROS
# container entry point (fun fact: '$' is the last line, 'i' inserts before
# it)
RUN  sed  --in-place                                            \
          --expression                                          \
          "\$isource /opt/${ROS_USER}/install/setup.bash"       \
          /ros_entrypoint.sh
    