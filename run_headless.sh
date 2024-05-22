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
}

trap cleanup EXIT

xhost +local:root

CURRENT_DISPLAY=$(echo $DISPLAY | sed 's/[^0-9]*//g')

container_ids=()

for i in {1..1}
do
  INSTANCE_ID=$i
  echo "Starting container with ID: slippi-emulation-$INSTANCE_ID"
  docker run --gpus all --rm \
    --name slippi-emulation-$INSTANCE_ID \
    -e INSTANCE_ID=$INSTANCE_ID \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -v $(pwd):/opt/melee \
    -w /opt/melee \
    slippi-emulator-headless \
    python3 ./scripts/example_headless.py > >(tee /dev/stdout) 2> >(tee /dev/stderr) &
  container_ids+=($!)
done

echo "Waiting for containers to stop..."
for pid in "${container_ids[@]}"
do
  wait $pid
  echo "Container process $pid has stopped."
done

cleanup
