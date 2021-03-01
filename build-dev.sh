REBUILD=0

while getopts 'r' opt; do
    case $opt in
        r) REBUILD=1 ;;
        *) echo 'Error in command line parsing' >&2
           exit 1
    esac
done
shift "$(( OPTIND - 1 ))"

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
MULTISTAGE_TARGET=develop
IMAGE_TAG=latest

if [ "$REBUILD" -eq 1 ]; then
	DOCKER_BUILDKIT=1 docker build \
    --no-cache \
    --target "$MULTISTAGE_TARGET" \
    --build-arg BASE_IMAGE=${BASE_IMAGE} \
    --build-arg BASE_TAG=${BASE_TAG} \
 		--build-arg UID=${UID} \
 		--build-arg GID=${GID} \
 		-t "$NAME":"$IMAGE_TAG" .
 else
	DOCKER_BUILDKIT=1 docker build \
    --target "$MULTISTAGE_TARGET" \
	  --build-arg BASE_IMAGE=${BASE_IMAGE} \
	  --build-arg BASE_TAG=${BASE_TAG} \
 		--build-arg UID=${UID} \
 		--build-arg GID=${GID} \
 		-t "$NAME":"$IMAGE_TAG" .
 fi