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

function Empty_Var_Control
{
    #|# Description : This function is used to check if a var is empty
    #|#
    #|# Var to set  :
    #|# 				EVC_Var_To_Test       : Use this var to set the path to test                                 ( Mandatory )
    #|# 				EVC_Var_Name_To_Test  : Use this var to set the name of the var to test for display messages ( Mandatory )
    #|# 				EVC_MSG_add           : Use this var to set complementary message                            ( OPTIONAL )
    #|# 				${1}                  : Used to set [ Base_Var_to_test ]
    #|# 				${2}                  : Used to set [ Base_Var_Name_To_Test ]
    #|# 				${3}                  : Used to set [ Type_Of_ERR ]
    #|#
    #|# Base usage  : Empty_Var_Control "My_VAR" "My_Var_Name" "ERR_type" "Level_Of_ERR" [ "MSG_add" "Action_ONFAIL" "Action_ONOK" ]
    #|#
    #|# Send Back   : Send back result of check

    EVC_Var_To_Test="${1}"
    EVC_Var_Name_To_Test="${2}"
    EVC_MSG_add="${3}"

    if [ -z "${EVC_Var_To_Test}" ]
    then
        echo  "Error ON VAR ${EVC_Var_Name_To_Test}  : [ Not Set ] ${MSG_Complement}" 
        exit 128
    else
        echo  "Value of ${EVC_Var_Name_To_Test}  : [ Value is ${EVC_Var_To_Test} ]" >> /tmp/init-1.log 
    fi
}

function CTRL_Result_func
{
    #|# Description : This function is used to check result of a past action and choose action
    #|#
    #|# Var to set  :
    #|# 				CRF_Result_Action             : Use this var to set The las action returne code         ( Mandatory )
    #|# 				CRF_Generic_Base_MSG          : use this var to set base message of control             ( Mandatory )
    #|# 				CRF_Generic_Base_MSG_ERR      : Use this var to set additional iformation on error      ( Mandatory )
    #|#
    #|# Base usage  : CTRL_Result_func "${?}" "Generic_Base_Param_MSG" "Generic_Base_Param_MSG_ERR" "Result_ERR_Level" "On fail action" "on success action"
    #|#
    #|# Send Back   : Message / Exit / function
    CRF_Result_Action=${1}
    CRF_Generic_Base_MSG=${2}
    CRF_Generic_Base_MSG_ERR=${3}

    echo -n "${CRF_Generic_Base_MSG}" 
    if [ "${CRF_Result_Action}" = "0" ]
    then
            echo "Sucess"
    else
            echo "failled"
            exit 128
    fi
    CRF_Generic_Base_MSG=""
}

function Dir_null_or_slash
{
    #|# Description : This function is used with CTRL_Result_func as success or error result
    #|#
    #|# Var to set  : 
    #|# 				Path_To_test : Use this var to set the path to test 
    #|# 				${1}         : use this var to set Path_To_test             
    #|#
    #|# Base usage  : Dir_null_or_slash  "My_directory_path"
    #|#
    #|# Send Back   : error check 
    Path_To_test=${1}

    if [ -z "${Path_To_test}" ] 
    then 
        echo  " Error ON PATH  : [ Value is NULL ]" 
        exit 1
    else 
        if [ "${Path_To_test}" = "/" ]
            then 
                echo " Error ON PATH  : [ Value is / ]" 
                exit 1
        fi
    fi
}

function Directory_CRT
{
    #|# Description : This function is used create a directory if is not present
    #|#
    #|# Var to set  : 
    #|# 				Base_param_Dir_To_Create    : use this var to set which irectory to control and create
    #|# 				${1}                        : use this var to set Base_param_Dir_To_Create        
    #|#
    #|# Base usage  : Directory_CRT "My_Directory"
    #|#
    #|# Send Back   : new directory  
    Base_param_Dir_To_Create="${1}"

    Dir_null_or_slash ${Base_param_Dir_To_Create}
    echo -n "Checking  directory : [ ${Base_param_Dir_To_Create} ] "
    if [ -d "${Base_param_Dir_To_Create}" ]
    then 
        echo "Present"
        else 
            mkdir -p ${Base_param_Dir_To_Create}
            Return_code=$?
            if [ "${Return_code}" = "0" ]
            then
                echo "CREATED"
            else
                echo "can't create directory : [ ${Base_param_Dir_To_Create} ]" 
                exit 1
            fi
    fi
}

function Directory_exist
{
    #|# Description : This function is used create a directory if is not present
    #|#
    #|# Var to set  : 
    #|# 				_CheckedDirectory    : use this var to set which irectory to control and create
    #|# 				${1}                        : use this var to set Base_param_Dir_To_Create        
    #|#
    #|# Base usage  : Directory_CRT "My_Directory"
    #|#
    #|# Send Back   : new directory  
    _CheckedDirectory="${1}"

    Dir_null_or_slash ${_CheckedDirectory}
    echo -n "Checking  directory : [ ${_CheckedDirectory} ] "
    if [ -d "${_CheckedDirectory}" ]
        then 
        echo "Present"
        else 
        echo "can't create directory : [ ${Base_param_Dir_To_Create} ]" 
                exit 1
    fi
}

function create_mount()
{
    #|# Description : This function is used to create mont point
    #|#
    #|# Var to set  :
    #|#               _mntpoint         : Use this var so set mount point to create
    #|# Base usage  :  create_mount "mountpoint"
    _mntpoint="${1}"
    Empty_Var_Control "${_mntpoint}"   "_mntpoint"    " no mount point defined "
    if [ -d ${_mntpoint} ]
        then 
            echo "warning directory already present "
            is_mounted "${_mntpoint}"
        else 
            mkdir ${_mntpoint} > /root/actionlog.log 2>&1 
            CTRL_Result_func "${?}" " Creating mount point  ${_mntpoint} " " [failled ] "
            is_mounted "${_mntpoint}"
    fi
}

function is_mounted()
{
  _mntpoint=${1}
  Empty_Var_Control "${_mntpoint}"   "_mntpoint"    " no mount point defined "
  cat /etc/mtab |awk '{ print "__" $2 "__" }'  | grep "__${_mntpoint}__" 
  if [ ${?} -eq 0 ]
     then 
          echo "already mounted"
     else 
          echo -n "Trying to mount ${_mntpoint} "
          mount ${_mntpoint} >> /tmp/init_1.log 2>&1 
          CTRL_Result_func "${?}" "   " " [failled ] " 
  fi
}

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



function Create_container () 
{
 _RootContainer="${1}"
 _ContainerName="${2}"   

  debootstrap --arch amd64 --include=systemd-container ${SystemUbuntuVersion} ${_RootContainer}/${_ContainerName}.${SystemUbuntuVersion} ${systemSrcUrl}


}




function RebuildFsTab() 
{
    cp /etc/fstab /etc/fstab.old

    echo "/dev/${VGName}/sys_lv_home              /home             xfs   noatime,nosuid,noexec,nodev,rw      0 2" >> /etc/fstab
    echo "/dev/${VGName}/sys_lv_var               /var              xfs   noatime,rw                          0 2" >> /etc/fstab
    echo "/dev/${VGName}/sys_lv_log               /var/log          xfs   noatime,nosuid,noexec,nodev,rw      0 2" >> /etc/fstab
    echo "/dev/${VGName}/sys_lv_tmp               /tmp              xfs   noatime,nosuid,noexec,nodev,rw      0 2" >> /etc/fstab
    echo "/dev/${VGName}/lv_srv                   /srv              xfs   noatime,nosuid,rw                   0 2" >> /etc/fstab
    echo "/dev/${VGName}/app_lv_config            /srv/config       xfs   ro,nosuid,noexec,noatime            0 2" >> /etc/fstab 
    echo "/dev/${VGName}/app_lv_data              /srv/data         xfs   noatime,nosuid,noexec,nodev,rw      0 2" >> /etc/fstab
    echo "/dev/${VGName}/app_lv_data_auth         /srv/data/auth    xfs   rw,nosuid,noexec,                   0 2" >> /etc/fstab 
    echo "/dev/${VGName}/app_lv_data_share        /srv/data/share   xfs   rw,nosuid,noexec,noatime            0 2" >> /etc/fstab 
    echo "/dev/${VGName}/app_lv_data_sgbd         /srv/data/sgbd    xfs   rw,nosuid,noexec,noatime            0 2" >> /etc/fstab 
    echo "/dev/${VGName}/app_lv_data_www          /srv/data/www     xfs   rw,nosuid,noexec,noatime            0 2" >> /etc/fstab 
    echo "/dev/${VGName}/lv_srv_run               /srv/data/run     xfs   noatime,rw                          0 2" >> /etc/fstab 
    echo "/dev/${VGName}/lv_srv_container         /srv/container    xfs   noatime,rw                          0 2" >> /etc/fstab
    echo "/dev/${VGName}/app_lv_log               /srv/data/log     xfs   noatime,rw                          0 2" >> /etc/fstab
    echo "/tmp                                    /srv/data/tmp     none  bind                                   " >> /etc/fstab 

}

#################################################################################################

RebuildFsTab
echo "Migrating home"
mv /home /home.old 
create_mount /home 
mv /home.old/* /home/ && rmdir /home.old

echo "migrating var"
echo "  Stoping log services ..."
service rsyslog stop 

echo "  Moving /var to /var.old"
tar -cvzf /var.tar.gz /var 
mv /var /var.old
CTRL_Result_func "${?}" " Moving data from  /var " " [failled ] "
create_mount /var 
create_mount /var/log 
echo "Moving logs /var/log "
tar -xvzf /var.tar.gz 
rm -rf /var.old 
CTRL_Result_func "${?}" " Moving data from  /var " " [failled ] "  
service rsyslog start 
echo "migrating tmp"
mv /tmp /tmp.old
create_mount /tmp 
mv  /tmp.old/* /tmp/
CTRL_Result_func "${?}" " Moving data from  /tmp " " [failled ] "
rm -rf /tmp.old 
CTRL_Result_func "${?}" " Removing /tmp.old " " [failled ] "
echo adding binding and links 
create_mount "/srv"
create_mount "/srv/config"  
mount -o remount,rw /srv/config
create_mount "/srv/data"    
create_mount "/srv/data/auth"
create_mount "/srv/data/share"
create_mount "/srv/data/sgbd" 
create_mount "/srv/data/www"  
create_mount "/srv/data/run"  
create_mount "/srv/container" 
create_mount "/srv/data/log"   

mkdir /srv/data/tmp

echo "creating Configuration dirs "
mkdir /srv/config/nspawn 
mkdir /srv/config/nspawn/container
mkdir /srv/config/nspawn/config
mkdir /srv/config/ldap
mkdir /srv/config/scripts
mkdir /srv/config/profiles   


mkdir /srv/admin
mkdir /srv/admin/scripts
mkdir /srv/admin/scripts/bin
ln -s /srv/config/scripts /srv/admin/scripts/config
mkdir /srv/admin/scripts/lib
mkdir /srv/data/log/scripts
ln -s /srv/data/log/scripts /srv/admin/scripts/logs
mkdir /srv/data/run/scripts 
ln -s /srv/data/run/scripts /srv/admin/scripts/data


ln -s /srv/config/nspawn/containers /etc/systemd/nspawn 
if [ -d /var/lib/machines ]
   then 
       rmdir rmdir /var/lib/machines 
fi 
ln -s /srv/container /var/lib/machines 

Create_container "/srv/container" "template"
init 6