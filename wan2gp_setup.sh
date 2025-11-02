#!/bin/bash

set -e

echo "🚀 Starting Wan2GP Setup..."

# Clone repository
if [ -d "Wan2GP" ]; then
    cd Wan2GP && git pull
else
    git clone https://github.com/lskenkf/Wan2GP.git && cd Wan2GP
fi

# Install Miniconda if not present
if [ ! -d "$HOME/miniconda3" ]; then
    wget -q https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
    chmod +x Miniconda3-latest-Linux-x86_64.sh
    ./Miniconda3-latest-Linux-x86_64.sh -b -p $HOME/miniconda3
    rm Miniconda3-latest-Linux-x86_64.sh
    echo 'export PATH="$HOME/miniconda3/bin:$PATH"' >> ~/.bashrc
fi

# Setup conda
export PATH="$HOME/miniconda3/bin:$PATH"
source $HOME/miniconda3/etc/profile.d/conda.sh

# Create environment and install packages
conda create -n wan2gp python=3.10.9 -y
conda activate wan2gp
pip install torch==2.7.1 torchvision torchaudio --index-url https://download.pytorch.org/whl/test/cu128
pip install -r requirements.txt

# Install system dependencies
sudo apt update && sudo apt install ffmpeg -y

echo "✅ Setup complete! Run 'conda activate wan2gp' to use."
