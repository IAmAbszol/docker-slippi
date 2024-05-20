#!/bin/bash

if [ -z "$INSTANCE_ID" ]; then
    echo "INSTANCE_ID is not set. Please make sure to pass the INSTANCE_ID environment variable."
    exit 1
fi

if [ ! -d /dev/snd ]; then
    echo "ALSA sound support not found. Please make sure to run the container with ALSA support."
    exit 1
fi

python3 -m venv /opt/melee/venv_$INSTANCE_ID
source /opt/melee/venv_$INSTANCE_ID/bin/activate
pip install melee

config_dir="/root/.config/SlippiOnline/Slippi_$INSTANCE_ID"
mkdir -p $config_dir

cleanup() {
    echo "Cleaning up..."
    deactivate
    rm -rf /opt/melee/venv_$INSTANCE_ID
}

trap cleanup EXIT

python3 /opt/melee/run.py
