#!/bin/bash

pushd /godot-src
    # Build editor binary
    /usr/local/bin/scons platform=linuxbsd target=editor tools=yes module_mono_enabled=yes mono_glue=no
    bin/godot.linuxbsd.tools.64.mono --generate-mono-glue /mnt/glue
    /usr/local/bin/scons platform=linuxbsd target=editor module_mono_enabled=yes tools=yes mono_glue=yes

    # Build export templates
    /usr/local/bin/scons platform=linuxbsd target=template_debug module_mono_enabled=yes
    /usr/local/bin/scons platform=linuxbsd target=template_release module_mono_enabled=yes
popd    
