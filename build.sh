#!/bin/bash

pushd /godot-src
    # Build editor binary
    /usr/local/bin/scons platform=linuxbsd target=editor module_mono_enabled=yes

    # Build export templates
    /usr/local/bin/scons platform=linuxbsd target=template_debug module_mono_enabled=yes
    /usr/local/bin/scons platform=linuxbsd target=template_release module_mono_enabled=yes
popd    
