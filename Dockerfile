ARG BASE_IMAGE=osrf/ros
ARG BASE_TAG=melodic-desktop

FROM ${BASE_IMAGE}:${BASE_TAG} as base-dependencies
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && apt-get install -y wget git vim bash-completion build-essential ros-melodic-joint-state-publisher-gui \
    && rm -rf /var/lib/apt/lists/*

ENV QT_X11_NO_MITSHM 1


FROM base-dependencies as develop

# Now create the same user as the host itself
ARG UID=1000
ARG GID=1000
RUN addgroup --gid ${GID} ros
RUN adduser --gecos "ROS User" --disabled-password --uid ${UID} --gid ${GID} ros
RUN usermod -a -G dialout ros
RUN echo "ros ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/99_aptget
RUN chmod 0440 /etc/sudoers.d/99_aptget && chown root:root /etc/sudoers.d/99_aptget

# Choose to run as user
ENV USER ros
USER ros

# Change HOME environment variable
ENV HOME /home/ros

# Change .bashrc
COPY config/update_bashrc /sbin/update_bashrc
RUN sudo chmod +x /sbin/update_bashrc \
 && sudo chown ros /sbin/update_bashrc \
 && sync \
 && /bin/bash -c /sbin/update_bashrc \
 && sudo rm /sbin/update_bashrc

# workspace setup
RUN mkdir -p ~/ros_ws/src

RUN cd ~/ros_ws/src && /bin/bash -c "source /ros_entrypoint.sh; catkin_init_workspace"
RUN cd ~/ros_ws && /bin/bash -c "source /ros_entrypoint.sh; catkin_make"

# Change entrypoint to source ~/.bashrc and start in ~
COPY config/entrypoint.sh /ros_entrypoint.sh
RUN sudo chmod +x /ros_entrypoint.sh \
 && sudo chown ros /ros_entrypoint.sh

RUN cd ~/ros_ws/src && mkdir hello

ENTRYPOINT ["/ros_entrypoint.sh"]
CMD ["bash"]


FROM base-dependencies as runtime

# Now create the same user as the host itself
ARG UID=1000
ARG GID=1000
RUN addgroup --gid ${GID} ros
RUN adduser --gecos "ROS User" --disabled-password --uid ${UID} --gid ${GID} ros
RUN usermod -a -G dialout ros
RUN echo "ros ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/99_aptget
RUN chmod 0440 /etc/sudoers.d/99_aptget && chown root:root /etc/sudoers.d/99_aptget

# Choose to run as user
ENV USER ros
USER ros

# Change HOME environment variable
ENV HOME /home/ros

# Change .bashrc
COPY config/update_bashrc /sbin/update_bashrc
RUN sudo chmod +x /sbin/update_bashrc \
 && sudo chown ros /sbin/update_bashrc \
 && sync \
 && /bin/bash -c /sbin/update_bashrc \
 && sudo rm /sbin/update_bashrc


# workspace setup
RUN mkdir -p ~/ros_ws/src

RUN cd ~/ros_ws/src && /bin/bash -c "source /ros_entrypoint.sh; catkin_init_workspace"
RUN cd ~/ros_ws/src && git clone https://github.com/domire8/franka_panda_rviz_visualization.git \
    && cd franka_panda_rviz_visualization \
    && git submodule init \
    && git submodule update
RUN cd ~/ros_ws && /bin/bash -c "source /ros_entrypoint.sh; catkin_make"

# Change entrypoint to source ~/.bashrc and start in ~
COPY config/entrypoint.sh /ros_entrypoint.sh
RUN sudo chmod +x /ros_entrypoint.sh \
 && sudo chown ros /ros_entrypoint.sh

RUN cd ~/ros_ws/src && mkdir hello

ENTRYPOINT ["/ros_entrypoint.sh"]
CMD ["bash"]
