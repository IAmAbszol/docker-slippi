FROM nvidia/cuda:12.4.1-cudnn-devel-ubuntu22.04

ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt-get update && apt-get install -y \
    sudo \
    wget \
    curl \
    xz-utils \
    libfuse2 \
    libusb-1.0-0 \
    libxrandr2 \
    libxinerama1 \
    libxcursor1 \
    libxi6 \
    libglu1-mesa \
    libglib2.0-0 \
    libgtk2.0-0 \
    libsm6 \
    libxext6 \
    libegl1-mesa \
    libdbus-1-3 \
    libxss1 \
    libxtst6 \
    libnss3 \
    libasound2 \
    libpulse0 \
    libudev1 \
    libgbm1 \
    libgl1-mesa-glx \
    xvfb \
    mesa-utils \
    python3 \
    python3-pip \
    python3-venv \
    git \
    unzip \
    libatk-bridge2.0-0 \
    libgtk-3-0 \
    libatk1.0-0 \
    libgdk-pixbuf2.0-0 \
    libpango-1.0-0 \
    libcairo2 \
    libxcomposite1 \
    libxdamage1 \
    libxrandr2 \
    alsa-utils \
    pulseaudio

# Setup vladfi1 Slippi
RUN mkdir -p /opt/slippi/ && \
    wget --no-check-certificate 'https://docs.google.com/uc?export=download&id=1I_GZz6Xtll2Sgy4QcOQbWK0IcQKdsF5X' -O /opt/slippi/Slippi_EXI_AI.AppImage && \
    cd /opt/slippi && \
    chmod +x ./Slippi_EXI_AI.AppImage && \
    ./Slippi_EXI_AI.AppImage --appimage-extract && \
    mv squashfs-root /opt/slippi-extracted && \
    mkdir -p /root/.config/SlippiOnline/

# Create and activate virtual environment, install libmelee
RUN python3 -m venv /opt/meleeenv && \
    . /opt/meleeenv/bin/activate && \
    python3 -m pip install git+https://github.com/vladfi1/libmelee.git

# Set the virtual environment as the default environment
ENV VIRTUAL_ENV=/opt/meleeenv
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

# Default command to run your application
CMD ["python3", "/opt/melee/run.py"]
