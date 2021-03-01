# franka_panda_rviz_visualization

Simple RViz visualization of the Franka Panda 7DOF robot. This repository is meant to provide an easy way to visualize
and write urdf.xacro files of the Franka Panda robot. It can easily be extened to other robots too.

Note: The *franka_panda_description* submodule is not the official *franka_description* package from the *franka_ros*
repository because it has better and more accurate description and urdf tags of the Franka Panda (
see [here](https://github.com/justagist/franka_panda_description)
and [here](https://hal.inria.fr/hal-02265293/document) for more detail).

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

There are two ways to run the docker image:

#### Build and run image locally (for developers)
If you want to build the image yourself and run the local image, use
```bash
./build.sh
./run.sh -l
```
in bash, or 

```bash
bash build.sh
bash run.sh -l
```
in zsh.

#### Pull the image from the repository
To pull the image from the GitHub Container Registry, run
```bash
./run.sh
```
in bash, or

```bash
bash run.sh
```
in zsh.

#### Using the container

The steps above create a Docker container with a shared volume that mounts the `src` directory of this repository directly to
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

## Development

To visualize and develop other robots from different urdf files and xacro macros, simply change the path in
visualization.launch to the desired file.