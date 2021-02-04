# franka_panda_rviz_visualization

Simple RViz visualization of the Franka Panda 7DOF robot. This repository is meant to provide an easy way to visualize
and write urdf.xacro files of the Franka Panda robot. It can easily be extened to other robots too.

## Usage instructions

### First steps

Clone this repository somewhere on your machine. Then,

```bash
cd franka_panda_rviz_visualization
git submodule init && git submodule update
```

Now, you can decide if you want to use the dockerized ROS or if you want to use this package with your local
installation of ROS Melodic.

### Docker Usage

First, build the image:

```bash
bash build.sh
```

Then, run the image:

```bash
bash run.sh
```

This creates a Docker container with a shared volume that mounts the `src` directory of this repository directly to
the `src` directory of the ROS workspace inside the container. Once you entered the container, simply run

```bash
cd ros_ws
catkin_make
roslaunch franka_panda_rviz_visualization visualization.launch
```

RViz should be launch showing a Franka Panda robot, as well as the joint state publisher GUI to change the positions of
the robot joints interactively.

### Usage with local ROS installation

After the first steps above, create a ROS workspace somewhere else on your machine:

```bash
mkdir ros_ws
cd ros_ws
ln -s /path/to/franka_panda_rviz_visulaization/src ./
cd src
catkin_init_workspace
cd ..
catkin_make
source devel/setup.bash
roslaunch franka_panda_rviz_visualization visualization.launch
```

RViz should be launch showing a Franka Panda robot, as well as the joint state publisher GUI to change the positions of
the robot joints interactively.