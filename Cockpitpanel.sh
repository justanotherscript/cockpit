#!/bin/bash

dnf update && dnf upgrade -y

egrep '^flags.*(vmx|svm)' /proc/cpuinfo | tee /home/cpuvirtinfo.txt 

cat /sys/module/kvm_intel/parameters/nested | tee /home/kvm_intel_nested_support.txt

df -h | tee /home/disk_usage.txt

dnf groupinfo virtualization
dnf install \
cockpit cockpit-machine libvirt libvirtd qemu-kvm virt-install libguestfs-tools firewall-cmd
dnf check-update
systemctl start libvirtd
systemctl start cockpit
systemctl enable cockpit.socket
firewall-cmd --permanent --zone=public --add-service=cockpit
firewall-cmd --reload

# Automatic unattendet upgrades

dnf install dnf-automatic -y
