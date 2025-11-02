#!/bin/bash
git clone https://github.com/lskenkf/Wan2GP.git
cd Wan2GP
wget -q https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh && chmod +x Miniconda3-latest-Linux-x86_64.sh && ./Miniconda3-latest-Linux-x86_64.sh -b -p $HOME/miniconda3 && echo 'export PATH="$HOME/miniconda3/bin:$PATH"' >> ~/.bashrc && source ~/.bashrc
conda init bash
source ~/.bashrc 
conda create -n wan2gp python=3.10.9
conda activate wan2gp
pip install torch==2.7.1 torchvision torchaudio --index-url https://download.pytorch.org/whl/test/cu128
pip install -r requirements.txt
sudo apt update
sudo apt install ffmpeg -y
