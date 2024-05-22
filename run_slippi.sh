#!/bin/bash

remove_existing_containers() {
  containers=$(docker ps -aq -f name=slippi-emulation)
  if [ ! -z "$containers" ]; then
    echo "Removing existing containers..."
    docker rm -f $containers
  fi
}

cleanup() {
  echo "Cleaning up..."
  xhost -local:root
  remove_existing_containers
  kill $XVFB_PID
  pulseaudio --kill
}

trap cleanup EXIT

xhost +local:root

CURRENT_DISPLAY=$(echo $DISPLAY | sed 's/[^0-9]*//g')
INSTANCE_ID=1
XVFB_DISPLAY=:$INSTANCE_ID

echo "Starting Xvfb on display $XVFB_DISPLAY"
Xvfb $XVFB_DISPLAY -screen 0 1024x768x24 +extension GLX +render -noreset &
XVFB_PID=$!

export DISPLAY=$XVFB_DISPLAY
pulseaudio --start

container_name="slippi-emulation-$INSTANCE_ID"
echo "Starting container with ID: $container_name"
docker run --gpus all --rm \
  --name $container_name \
  -e INSTANCE_ID=$INSTANCE_ID \
  -e DISPLAY=$XVFB_DISPLAY \
  -v /tmp/.X11-unix:/tmp/.X11-unix \
  -v $(pwd):/opt/melee \
  -w /opt/melee \
  slippi-emulator \
  python3 ./scripts/example_visual.py

cleanup
