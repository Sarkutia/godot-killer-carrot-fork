#!/bin/bash

# Install dependencies
dnf install -y sudo
sudo dnf update -y
sudo dnf install -y \
  pkgconfig \
  gcc-c++ \
  libstdc++-static \
  wayland-devel \
  wget
wget https://bootstrap.pypa.io/get-pip.py
sudo python3 ./get-pip.py
sudo python3 -m pip install --upgrade pip
sudo python3 -m pip install scons
sudo dnf -y install dotnet-sdk-9.0 python3
export PATH="/usr/local/bin:$PATH"

# Build c++
sudo rm -rf bin
mkdir bin
sudo chmod 777 bin
scons platform=linuxbsd target=editor tools=yes module_mono_enabled=yes mono_glue=yes

# Build export templates
scons platform=linuxbsd target=template_debug module_mono_enabled=yes
scons platform=linuxbsd target=template_release module_mono_enabled=yes

# Generate glue
sudo rm -rf modules/mono/glue
mkdir -p modules/mono/glue
sudo chmod 777 modules/mono/glue
./bin/godot.linuxbsd.editor.x86_64.mono --headless --generate-mono-glue ./modules/mono/glue

# Install this version of the killer carrot godot fork as a nuget package
dotnet nuget locals all --clear
sudo rm -rf ~/MyLocalNugetSource
mkdir ~/MyLocalNugetSource
dotnet nuget remove source MyLocalNugetSource
dotnet nuget add source ~/MyLocalNugetSource --name MyLocalNugetSource

# Generate binaries
sudo python3 modules/mono/build_scripts/build_assemblies.py --godot-output-dir=./bin --push-nupkgs-local ~/MyLocalNugetSource --godot-platform=linuxbsd

# Add godot to path
echo "$(pwd)/bin/godot.linuxbsd.editor.x86_64.mono" | sudo tee /usr/bin/godot > /dev/null
sudo chmod +x /usr/bin/godot
