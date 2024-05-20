# Docker Slippi

## Author Kyle Darling

## Overview

Purpose of this repository is to provide an interface that allows for the construction and destruction of Docker containers capable of running Slippi in a headless manner. In turn the containers themselves can be used for Reinforcement Learning training in a hive like manner.

## Goal

Run Slippi in a headless manner while using alt4/libmelee (pip install melee) to train a Imitation Learning + Reinforcement Learning model capable of playing Melee. Imitation Learning yielded an AI that matched the players attitude, fundamental technical concepts, however lacked the understanding of the game. The goal of this hive is to use this base model as a way to train an agent with a starting point utilizing Reinforcement Learning or newer approaches found by the scientific community. Once trained, the agent should be capable of executing basic recovery approaches, etc while understanding the consequences of their actions.

Example: Ganondorf Melee AI is capable of Wavedash + Jab while CC'ing, common tech brought upon by **n0ne** and used by myself, **Abszol**. The AI though flubs recoveries, unable to consistently grab ledge, something basic. The understanding could be lack of data, etc however from what is known about Imitation Learning is that it lacks the fundamental reasoning as to why they're performing such action, in our case grabbing ledge is very important and other micro actions that yield to stock differences begin to snowball.

## Requirements

* Docker
* [Nvidia CUDA](https://hub.docker.com/r/nvidia/cuda/tags)
* Ubuntu >= 20.04

## Setup

Nothing! Simply put the container runs Slippi directly from the container, however we need to modify our scripts accordingly. The base scripts used in this repository are subject to change but the callstacks are all the same.

* **run_docker.sh**: Runs the Docker container by running each container in a detached state, cleanup at the end of execution.
* **setup.sh**: Script passed to the container to run, mounted in /opt/melee by **run_docker.sh**. Goal for setup.sh is to provide the base environment setup for **run.py** to execute.
* **run.py**: Main running script for melee.

