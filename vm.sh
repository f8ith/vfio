#!/bin/bash

set -e

if [[ $EUID -ne 0 ]]; then
  echo "this script must be run as the super-user"
  exit 1
fi

for dev in "0000:0a:00.0" "0000:0a:00.1"; do
  if [[ ! -e "/sys/bus/pci/drivers/vfio-pci/$dev" && -e \
    "/sys/bus/pci/devices/$dev/driver" ]]; then
    echo -n "$dev setting device driver matching rules..."
    echo "vfio-pci" > "/sys/bus/pci/devices/$dev/driver_override"
    echo " done"

    echo -n "$dev unbinding device from current driver..."
    echo "$dev" > "/sys/bus/pci/devices/$dev/driver/unbind"
    while [[ -e "/sys/bus/pci/devices/$dev/driver" ]]; do
      sleep 0.1
    done
    echo " done"
  fi
done

for dev in "0000:0a:00.0" "0000:0a:00.1"; do
  if [[ ! -e "/sys/bus/pci/drivers/vfio-pci/$dev" ]]; then
    echo -n "$dev binding device to vfio-pci driver..."
    echo "$dev" > "/sys/bus/pci/drivers/vfio-pci/bind"
    while [[ ! -e "/sys/bus/pci/devices/$dev/driver" ]]; do
      sleep 0.1
    done
    echo " done"
  fi
done

echo "updating xorg monitor configuration"
cp -v "/home/faith/.local/share/vfio/vm_10-monitor.conf" "/etc/X11/xorg.conf.d/10-monitor.conf"

exit 0
