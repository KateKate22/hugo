#!/usr/bin/env bash
set -e
SCRIPT_DIR=$(dirname "${BASH_SOURCE[0]}")
source "$SCRIPT_DIR/ansi.sh"

print_help() {
  printf "\n" >&2
  printf "This script builds docker images.\n" >&2
  printf "\n" >&2
  printf "USAGE:\n" >&2
  printf "    ${CYAN}./docker.sh${RESET} [options]\n" >&2
  printf "\n" >&2
  printf "OPTIONS: \n" >&2
  printf "    -t <name>, --tag <name>     - set docker image name\n" >&2
  printf "    -e <path>, --export <path>  - export docker image into tar file\n" >&2
  printf "    -h, --help                  - print help and exit\n" >&2
  printf "\n" >&2
  printf "ENV VARIABLES: \n" >&2
  printf "    DOCKER_REGISTRY             - (optional) address of docker registry\n" >&2
  printf "\n" >&2
}

DOCKER_IMAGE_NAME="nsdt-gohugo"
while [ "$1" != "" ]; do
  case "$1" in
  -h | --help)
    print_help
    exit
    ;;
  -t | --tag)
    shift
    DOCKER_IMAGE_NAME="$1"
    ;;
  *)
    printf "${RED}Invalid argument \"$1\"${RESET}\n" >&2
    exit 1
    ;;
  esac
  shift
done


if [ -f "./artifacts/version.sh" ]; then
  source ./artifacts/version.sh
fi

if [ ! -z "$DOCKER_REGISTRY" ]; then
  DOCKER_IMAGE_NAME="$DOCKER_REGISTRY/$DOCKER_IMAGE_NAME"
fi

echo "DOCKER_VERSION_TAGS=[${DOCKER_VERSION_TAGS[@]}]"
if [ ! -z ${DOCKER_VERSION_TAGS[0]} ]; then
  DOCKER_IMAGE="$DOCKER_IMAGE_NAME:${DOCKER_VERSION_TAGS[0]}"
else
  DOCKER_IMAGE="$DOCKER_IMAGE_NAME:latest"
fi

printf "${CYAN}Building docker image $DOCKER_IMAGE${RESET}\n" >&2
printf "${GRAY}+ docker build  -t \"$DOCKER_IMAGE\" \"$SCRIPT_DIR/../\" ${RESET}\n" >&2
docker build -t "$DOCKER_IMAGE" "$SCRIPT_DIR/../"

mkdir -p ./artifacts/
echo "$DOCKER_IMAGE" >./artifacts/DOCKER_IMAGES
for ((i = 1; i < ${#DOCKER_VERSION_TAGS[@]}; i++)); do
  DOCKER_IMAGE_ALT="${DOCKER_IMAGE_NAME}:${DOCKER_VERSION_TAGS[$i]}"
  printf "${DARK_YELLOW}+ docker tag $DOCKER_IMAGE $DOCKER_IMAGE_ALT${RESET}\n" >&2
  docker tag "$DOCKER_IMAGE" "$DOCKER_IMAGE_ALT"
  printf "Docker image ${YELLOW}$DOCKER_IMAGE${RESET} has been also tagged as ${YELLOW}$DOCKER_IMAGE_ALT${RESET}\n" >&2
  echo "$DOCKER_IMAGE_ALT" >>./artifacts/DOCKER_IMAGES

  printf "${CYAN}Publishing docker image $DOCKER_IMAGE_ALT${RESET}\n"
  printf "${GRAY}+ docker push $DOCKER_IMAGE_ALT${RESET}\n"
  docker push "$DOCKER_IMAGE_ALT"
done
