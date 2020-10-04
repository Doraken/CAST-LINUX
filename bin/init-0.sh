#!/bin/bash

#Config
BaseHdd="/dev/sda"
BaseLVfs="${BaseHdd}4" 
HostNameBase=$(hostname)
VGName="VG_${HostNameBase}_01"
SystemUbuntuVersion="$(cat /etc/apt/sources.list | grep ^deb | grep main | awk '{ print $3 }' | egrep -v \-)"
systemSrcUrl="$(cat /etc/apt/sources.list | grep ^deb | grep main  | awk '{ print $2 }' |sort -u  | egrep -v security)"
containerDomaine="internal.yorick.doraken.net" 
containerInfra="172.16.1.2"
NetbridgeNet="172.16.1.1"
NetGateway="172.16.1.1"
NetworkDevice="$( ip addr show  |grep mtu |egrep -v lo | awk '{ print $2 }' | awk -F\: '{ print $1}' | grep en )"
NetworkBridge="br0"
DefaultSleepValue="1"

############################################### 
function set_lvm_VG()
{
  _VgDisk="${1}"
  _VgName="${2}"

  if [ -a /dev/${_HDD_vol} ]
      then
          echo -n "Volume found Creating private for LVM"
          pvcreate ${_VgDisk}  
          if [ ${?} = "0" ]
            then
              echo " [ SUCCESS ]"
            else
              echo " [ FAILLED ]"
              exit 1
          fi
          echo -n "Creating volume group ${_VgName}"
          vgcreate ${_VgName} ${_VgDisk}
          if [ ${?} = "0" ]
            then
              echo " [ SUCCESS ]"
            else
              echo " [ FAILLED ]"
              exit 1
          fi
      else
          echo "Can't find volume"
          exit 1
  fi
}

#################################################################################################
echo "init install packages"
apt-get update -y
apt-get upgrade -y
apt-get install software-properties-common -y
add-apt-repository universe
add-apt-repository multiverse
apt-get update -y 
apt-get upgrade -y 
apt-get dist-upgrade -y 

apt-get install ca-certificate -y
apt-get install open-infrastructure-container-tools sshguard vim lvm2 xfsprogs aide lsb-release apt-transport-https git net-tools -y
apt-get install --no-install-recommends debootstrap systemd-container debian-archive-keyring -y



cd /

echo "Disabling IPV6"
cp /etc/sysctl.conf /etc/sysctl.old
echo "disabling IPV6"
echo  "net.ipv6.conf.all.disable_ipv6=1"       
echo  "net.ipv6.conf.default.disable_ipv6=1"
echo  "net.ipv6.conf.lo.disable_ipv6=1"
sysctl -w net.ipv6.conf.all.disable_ipv6=1
sysctl -w net.ipv6.conf.default.disable_ipv6=1
cp /etc/default/grub /etc/default/grub.old
sed -i 's/GRUB_CMDLINE_LINUX\=\"\"/GRUB_CMDLINE_LINUX\=\"ipv6.disable\=1\"/g' /etc/default/grub
update-grub

#RebuildNetwork

echo "Unmounting /srv"
umount /srv && mv /etc/fstab /etc/fstab.old  && cat /etc/fstab.old  | egrep -v \/srv > /etc/fstab 

echo "Changing partition type for ${BaseHdd}"
fdisk ${BaseHdd} <<EOF
t
4
8e

w
EOF

echo "creating VG"
pvcreate ${BaseLVfs}
set_lvm_VG  ${BaseLVfs} ${VGName}
init 6 

