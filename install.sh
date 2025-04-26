#!/bin/bash

# install dependencies for local godot development on this machine
sudo dnf -y install dotnet-sdk-9.0 python3

# create a build of killer carrot godot fork from this source
podman build --tag godotbuild .

# run the container
mkdir bin
sudo chmod 777 bin
podman run --rm -v ./bin:/mnt/bin godotbuild:latest

# install this version of the killer carrot godot fork as a nuget package
rm ~/MyLocalNugetSource/*
mkdir ~/MyLocalNugetSource
dotnet nuget add source ~/MyLocalNugetSource --name MyLocalNugetSource

# Generate glue sources
bin/godot.linuxbsd.editor.x86_64.mono --headless --generate-mono-glue modules/mono/glue

# Generate binaries
sudo python3 modules/mono/build_scripts/build_assemblies.py --godot-output-dir=./bin --push-nupkgs-local ~/MyLocalNugetSource --godot-platform=linuxbsd

# Add godot to path
echo "$(pwd)/bin/godot.linuxbsd.editor.x86_64.mono" | sudo tee /usr/bin/godot > /dev/null
sudo chmod +x /usr/bin/godot
