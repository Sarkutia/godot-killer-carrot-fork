#!/bin/bash

pushd /godot-src
    # Build editor binary
    /usr/local/bin/scons platform=linuxbsd target=editor tools=yes module_mono_enabled=yes mono_glue=yes
    /godot-src/bin/godot.linuxbsd.tools.64.mono --generate-mono-glue /mnt/glue

    # Build export templates
    /usr/local/bin/scons platform=linuxbsd target=template_debug module_mono_enabled=yes
    /usr/local/bin/scons platform=linuxbsd target=template_release module_mono_enabled=yes
popd    
