#!/bin/bash

# Wan2GP One-Click Setup Script
# This script automates the complete installation of Wan2GP

set -e  # Exit on any error

echo "🚀 Starting Wan2GP Setup..."
echo "================================="

# Function to print colored output
print_status() {
    echo -e "\033[1;34m$1\033[0m"
}

print_success() {
    echo -e "\033[1;32m✅ $1\033[0m"
}

print_error() {
    echo -e "\033[1;31m❌ $1\033[0m"
}

# Check if running on Linux
if [[ "$OSTYPE" != "linux-gnu"* ]]; then
    print_error "This script is designed for Linux systems only"
    exit 1
fi

# Step 1: Clone the repository
print_status "Step 1: Cloning Wan2GP repository..."
if [ -d "Wan2GP" ]; then
    print_status "Wan2GP directory exists, updating..."
    cd Wan2GP
    git pull
else
    git clone https://github.com/lskenkf/Wan2GP.git
    cd Wan2GP
fi
print_success "Repository cloned/updated successfully"

# Step 2: Install Miniconda if not already installed
print_status "Step 2: Setting up Miniconda..."
if [ ! -d "$HOME/miniconda3" ]; then
    print_status "Downloading and installing Miniconda..."
    wget -q https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
    chmod +x Miniconda3-latest-Linux-x86_64.sh
    ./Miniconda3-latest-Linux-x86_64.sh -b -p $HOME/miniconda3
    rm Miniconda3-latest-Linux-x86_64.sh
    
    # Add conda to PATH if not already there
    if ! grep -q "miniconda3/bin" ~/.bashrc; then
        echo 'export PATH="$HOME/miniconda3/bin:$PATH"' >> ~/.bashrc
    fi
    print_success "Miniconda installed successfully"
else
    print_success "Miniconda already installed"
fi

# Initialize conda for bash
export PATH="$HOME/miniconda3/bin:$PATH"
source $HOME/miniconda3/etc/profile.d/conda.sh

# Step 3: Create and activate conda environment
print_status "Step 3: Creating conda environment 'wan2gp'..."
if conda env list | grep -q "wan2gp"; then
    print_status "Environment 'wan2gp' already exists, updating..."
    conda activate wan2gp
else
    conda create -n wan2gp python=3.10.9 -y
    conda activate wan2gp
fi
print_success "Conda environment ready"

# Step 4: Install PyTorch
print_status "Step 4: Installing PyTorch..."
pip install torch==2.7.1 torchvision torchaudio --index-url https://download.pytorch.org/whl/test/cu128
print_success "PyTorch installed successfully"

# Step 5: Install requirements
print_status "Step 5: Installing Python requirements..."
if [ -f "requirements.txt" ]; then
    pip install -r requirements.txt
    print_success "Requirements installed successfully"
else
    print_error "requirements.txt not found in the repository"
    echo "Continuing with setup..."
fi

# Step 6: Install system dependencies
print_status "Step 6: Installing system dependencies..."
if command -v apt >/dev/null 2>&1; then
    if [ "$EUID" -eq 0 ]; then
        apt update && apt install ffmpeg -y
    else
        echo "Installing ffmpeg (requires sudo)..."
        sudo apt update && sudo apt install ffmpeg -y
    fi
    print_success "System dependencies installed"
else
    print_error "apt package manager not found. Please install ffmpeg manually."
fi

# Step 7: Final setup verification
print_status "Step 7: Verifying installation..."
python -c "import torch; print(f'PyTorch version: {torch.__version__}')" || print_error "PyTorch verification failed"
which ffmpeg >/dev/null && print_success "ffmpeg is available" || print_error "ffmpeg not found"

echo ""
echo "🎉 Setup Complete!"
echo "================================="
echo "To use Wan2GP:"
echo "1. Activate the environment: conda activate wan2gp"
echo "2. Navigate to the project: cd $(pwd)"
echo "3. Run your scripts!"
echo ""
echo "Note: You may need to restart your terminal or run 'source ~/.bashrc' for conda to work properly."

# Create activation script for convenience
cat > activate_wan2gp.sh << 'EOF'
#!/bin/bash
# Quick activation script for Wan2GP
source $HOME/miniconda3/etc/profile.d/conda.sh
conda activate wan2gp
echo "Wan2GP environment activated!"
echo "Current directory: $(pwd)"
EOF

chmod +x activate_wan2gp.sh
print_success "Created activation script: ./activate_wan2gp.sh"
