if [ "$(uname -s)" != "Linux" ]; then
  echo "This Docker image is currently only running on Linux. Aborting the build..."
  exit 1
fi

BASE_IMAGE=osrf/ros
BASE_TAG=melodic-desktop

docker pull ${BASE_IMAGE}:${BASE_TAG}

UID="$(id -u "${USER}")"
GID="$(id -g "${USER}")"

if [ "$(uname -s)" = "Darwin" ]; then
    GID=1000
fi

NAME=$(echo "${PWD##*/}" | tr _ -)
MULTISTAGE_TARGET=runtime
IMAGE_TAG=nightly

DOCKER_BUILDKIT=1 docker build \
  --target "$MULTISTAGE_TARGET" \
  --build-arg BASE_IMAGE=${BASE_IMAGE} \
  --build-arg BASE_TAG=${BASE_TAG} \
  --build-arg UID=${UID} \
  --build-arg GID=${GID} \
  -t ghcr.io/domire8/franka-panda-rviz-visualization/"$NAME":"$IMAGE_TAG" .

docker push ghcr.io/domire8/franka-panda-rviz-visualization/"$NAME":"$IMAGE_TAG"