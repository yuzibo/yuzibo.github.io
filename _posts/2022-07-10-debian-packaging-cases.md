---
title: Debian packaging cases
category: debian-riscv
layout: post
---
* content
{:toc}

# makefile

```bash
#!/usr/bin/make -f

%:
        dh $@ --buildsystem=makefile

override_dh_auto_build:
        cd Platform/Linux/CreateRedist && ./RedistMaker

override_dh_clean:
        dh_clean -X Platform/Win32/CreateRedist/EE_NI/Includes/EENIVariables.wxi.bak
        rm -rf -- Platform/Linux/Bin/
        rm -rf -- Platform/Linux/Build/Utils/XnSensorServer/*-Release/
        rm -rf -- Platform/Linux/Build/XnCore/*-Release/
        rm -rf -- Platform/Linux/Build/XnDDK/*-Release/
        rm -rf -- Platform/Linux/Build/XnDeviceFile/*-Release/
        rm -rf -- Platform/Linux/Build/XnDeviceSensorV2/*-Release/
        rm -rf -- Platform/Linux/Build/XnFormats/*-Release/
        rm -rf -- Platform/Linux/CreateRedist/Final/
        rm -rf -- Platform/Linux/Redist/
# cat Platform/Linux/CreateRedist/RedistMaker
# Build Engine
echo "Building..."
make -C ../Build clean > /dev/null
make -C ../Build

```

点评：  针对makefile的rules编写。