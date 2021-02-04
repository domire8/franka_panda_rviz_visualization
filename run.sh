NAME=$(echo "${PWD##*/}" | tr _ -)
TAG=melodic-desktop

# create a shared volume to store the ros_ws
docker volume create --driver local \
    --opt type=none \
    --opt device=$PWD/src \
    --opt o=bind \
    ${NAME}_ros_ws_vol

xhost +
docker run \
  --privileged \
	--net=host \
	-it \
	--rm \
	--env="DISPLAY" \
	--volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
	--volume="${NAME}_ros_ws_vol:/home/ros/ros_ws/src:rw" \
	$NAME:$TAG