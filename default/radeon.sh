#!/bin/bash

if [[ $EUID -ne 0 ]]
then
        echo "this script must be run as the super-user"
        exit 1
fi

echo "copying module configuration"
cp -v ./modprobe/nvidia.conf /etc/modprobe.d/nvidia.conf
cp -v ./modprobe/vfio.conf /etc/modprobe.d/vfio.conf

# not loading vfio modules on boot break manual switching scripts since
# they don't modprobe missing modules at the moment
# therefore they should always be loaded and won't be touched by this script
#cp -v ./modules-load/vfio.conf /etc/modules-load.d/vfio.conf

echo "updating xorg monitor configuration"
cp -v ../radeon_10-monitor.conf /etc/X11/xorg.conf.d/10-monitor.conf
