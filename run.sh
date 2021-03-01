LOCAL=0
while getopts 'l' opt; do
    case $opt in
        l) LOCAL=1 ;;
        *) echo 'Error in command line parsing' >&2
           exit 1
    esac
done
shift "$(( OPTIND - 1 ))"

if [ "$(uname -s)" != "Linux" ]; then
  echo "This Docker image is currently only running on Linux. Aborting..."
  exit 1
fi

if [ "$LOCAL" -eq 1 ]; then
  NAME=$(echo "${PWD##*/}" | tr _ -)
  # create a shared volume to store the ros_ws
  docker volume create --driver local \
    --opt type=none \
    --opt device="$PWD"/src \
    --opt o=bind \
    "${NAME}"_ros_ws_vol

  xhost +
  docker run \
    --privileged \
    --net=host \
    -it \
    --rm \
    --env="DISPLAY" \
    --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
    --volume="${NAME}_ros_ws_vol:/home/ros/ros_ws/src:rw" \
    "$NAME"/develop:latest
else
  PACKAGE_NAME=ghcr.io/domire8/franka-panda-rviz-visualization/franka-panda-rviz-visualization:nightly
  docker pull $PACKAGE_NAME
  xhost +
  docker run \
    --privileged \
    --net=host \
    -it \
    --rm \
    --env="DISPLAY" \
    --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
    "$PACKAGE_NAME"
fi
