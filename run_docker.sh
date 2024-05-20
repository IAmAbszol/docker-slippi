#!/bin/bash

xhost +local:docker

CURRENT_DISPLAY=$(echo $DISPLAY | sed 's/[^0-9]*//g')

remove_existing_containers() {
    containers=$(docker ps -aq -f name=slippi-emulation)
    if [ ! -z "$containers" ]; then
        echo "Removing existing containers..."
        docker rm -f $containers
    fi
}

cleanup_containers() {
    echo "Cleaning up containers..."
    xhost -local:docker
    remove_existing_containers
}

trap cleanup_containers EXIT

container_ids=()

for i in {1..2}
do
    INSTANCE_ID=$i
    container_id=$(docker run --gpus all --rm -d \
        --name slippi-emulation-$INSTANCE_ID \
        --device /dev/snd \
        -e DISPLAY=:${CURRENT_DISPLAY} \
        -e INSTANCE_ID=$INSTANCE_ID \
        -v /tmp/.X11-unix:/tmp/.X11-unix:ro \
        -v $(pwd):/opt/melee \
        slippi-emulator /opt/melee/setup.sh)
    container_ids+=($container_id)
    echo "Started container with ID: $container_id"
done

echo "Waiting for containers to stop..."
for container_id in "${container_ids[@]}"
do
    while [ "$(docker ps -q -f id=$container_id)" ]; do
        sleep 1
    done
    echo "Container $container_id has stopped."
done

cleanup_containers
