#!/bin/bash

BUILD_CONTEXT="."

docker build -t slippi-emulator -f Dockerfile_libmelee $BUILD_CONTEXT
docker build -t slippi-emulator-headless -f Dockerfile_headless $BUILD_CONTEXT
