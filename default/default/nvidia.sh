#!/bin/bash

if [[ $EUID -ne 0 ]]
then
        echo "this script must be run as the super-user"
        exit 1
fi

echo "removing module configuration"
rm -v /etc/modprobe.d/nvidia.conf
rm -v /etc/modprobe.d/vfio.conf

# not loading vfio modules on boot break manual switching scripts since
# they don't modprobe missing modules at the moment
# therefore they should always be loaded and won't be touched by this script
#rm -v /etc/modules-load.d/vfio.conf

echo "updating xorg monitor configuration"
cp -v ../nvidia_10-monitor.conf /etc/X11/xorg.conf.d/10-monitor.conf
