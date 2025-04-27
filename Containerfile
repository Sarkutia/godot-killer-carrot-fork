FROM ubi9:latest

# Install dependencies
RUN dnf install -y sudo

RUN sudo dnf update -y

RUN sudo dnf install -y \
  pkgconfig \
  gcc-c++ \
  libstdc++-static \
  wayland-devel \
  wget

RUN wget https://bootstrap.pypa.io/get-pip.py

RUN sudo python3 ./get-pip.py

RUN sudo python3 -m pip install --upgrade pip
RUN sudo python3 -m pip install scons

RUN sudo dnf -y install dotnet-sdk-9.0

COPY . /godot-src

RUN sudo /godot-src/build.sh

ENTRYPOINT ["/godot-src/entrypoint.sh"]