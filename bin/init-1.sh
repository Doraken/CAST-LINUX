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

function create_xfs()
{
    _VgName="${1}"
    _LvName="${2}"

    Empty_Var_Control "${_VgName}"   "_VgName"    " volume goup name is a mandatory parameter "
    Empty_Var_Control "${_LvName}"   "_LvName"    " logical volume name is a mandatory parameter "

    LVM_Device_exist "${_LvName}" "${_VgName}" 

    mkfs.xfs -f  /dev/${_VgName}/${_LvName} 
}




function LVM_Device_Create
{
  #|# Var to set  : 
  #|# _LvName : Use this var to set name of the created lv ( Mandatory )
  #|# _lvSize : Use this var to set size of the created lv ( Mandatory )
  #|# _VgName : Use this var to set name of the used vg    ( Mandatory )
  #|# ${1}          : Use this var to set [ _LvName ]                   
  #|# ${2}          : Use this var to set [ _lvSize ]
  #|# ${3}          : Use this var to set [ _VgName ]                 
  #|#
  #|# Base usage  : LVM_Device_Create "_LvName" "_lvSize" "_VgName" 
  #|#
  #|# Description : This function is used to creat lvm logical volume
  #|#
  #|# Send Back   : lvm logical volume


  _LvName="${1}"                    
  _lvSize="${2}" 
  _VgName="${3}"  

  Empty_Var_Control "${_LvName}" "_LvName" " logical volume name is a mandatory parameter "
  Empty_Var_Control "${_lvSize}" "_lvSize" " logical volume size is a mandatory parameter "
  Empty_Var_Control "${_VgName}" "_VgName" " volume group name is a mandatory parameter "

  lvcreate -L ${_lvSize} -n ${_LvName} ${_VgName} 
  CTRL_Result_func "${?}" "Creation of logical volume ${_LvName} on vg ${_VgName}" " [ can't create ] " 
  LVM_Device_exist "${_LvName}" "${_VgName}" 
  create_xfs "${_VgName}" "${_LvName}"
}


function LVM_Device_exist
{
  #|# Var to set  : 
  #|# LVMDEX_Name_lv        : Use this var to set Logical volume name to check ( Mandatory )
  #|# LVMDEX_VG_NAME        : Use this var to set Volume group name of the lv  ( Mandatory )
  #|# ${1}          : Use this var to set [ LVMDEX_Name_lv ]                   
  #|# ${2}          : Use this var to set [ LVMDEX_VG_NAME ]
  #|#
  #|# Base usage  : LVM_Device_delete "LVMDEX_Name_lv" "LVMDEX_VG_NAME"  "LVMDEX_err_level" "LVMDEX_On_Fail_Action" "LVMDEX_On_ok_Action"
  #|#
  #|# Description : This function is used to check existance of a lvm logical volume
  #|#
  #|# Send Back   : lvm logical volume Information and action 


  LVMDEX_Name_lv="${1}"                 
  LVMDEX_VG_NAME="${2}"

  Empty_Var_Control "${LVMDEX_Name_lv}"   "LVMDEX_Name_lv"    " logical volume name is a mandatory parameter "
  Empty_Var_Control "${LVMDEX_VG_NAME}"   "LVMDEX_VG_NAME"    " volume group name is a mandatory parameter "


  lvdisplay  /dev/${LVMDEX_VG_NAME}/${LVMDEX_Name_lv} > /dev/null
  CTRL_Result_func "${?}" "Status of logical volume ${LVMDEX_Name_lv} on vg ${LVMDEX_VG_NAME}" " [ Not present ] " 
}



function RebuildNetwork()
{
    echo "Generating network Device"
    echo "[Match]"                       > /etc/systemd/network/20-wired.network
    echo "Name=${NetworkDevice}"        >> /etc/systemd/network/20-wired.network
    echo ""                             >> /etc/systemd/network/20-wired.network
    echo "[Network]"                    >> /etc/systemd/network/20-wired.network
    echo "DHCP=yes"                     >> /etc/systemd/network/20-wired.network
    echo "Generating bridge Device"
    echo "[NetDev]"                      > /etc/systemd/network/21-bridge.netdev
    echo "Name=${NetworkBridge}"        >> /etc/systemd/network/21-bridge.netdev
    echo "Kind=bridge"                  >> /etc/systemd/network/21-bridge.netdev
    echo "Generating bridge link"
    echo "[Match]"                       >  /etc/systemd/network/22-bridge-bind.network
    echo "Name=${NetworkDevice}"        >>  /etc/systemd/network/22-bridge-bind.network
    echo ""                             >>  /etc/systemd/network/22-bridge-bind.network
    echo "[Network]"                    >>  /etc/systemd/network/22-bridge-bind.network
    echo "Bridge=${NetworkBridge}"      >>  /etc/systemd/network/22-bridge-bind.network
    echo "Generating bridge network configuration"
    echo "[Match]"                       >  /etc/systemd/network/23-bridge-net.network
    echo "Name=br*"                     >>  /etc/systemd/network/23-bridge-net.network
    echo "Driver=bridge"                >>  /etc/systemd/network/23-bridge-net.network
    echo ""                             >>  /etc/systemd/network/23-bridge-net.network
    echo "[Network]"                    >>  /etc/systemd/network/23-bridge-net.network
    echo "DNS=8.8.8.8"                  >>  /etc/systemd/network/23-bridge-net.network
    echo "Address=${NetbridgeNet}/24"   >>  /etc/systemd/network/23-bridge-net.network
    echo "DHCPServer=yes"               >>  /etc/systemd/network/23-bridge-net.network
    echo "IPMasquerade=yes"             >>  /etc/systemd/network/23-bridge-net.network
    echo "LinkLocalAddressing=no"       >>  /etc/systemd/network/23-bridge-net.network
    echo "LLDP=yes"                     >>  /etc/systemd/network/23-bridge-net.network
     echo "EmitLLDP=customer-bridge"    >>  /etc/systemd/network/23-bridge-net.network

}

function BuildLvs ()
{
    echo "Create system home volume for /home"
    LVM_Device_Create "sys_lv_home"      "2G"   "${VGName}"
    sleep ${DefaultSleepValue}
    echo "Create system log volume for /var"
    LVM_Device_Create "sys_lv_var"       "10G"  "${VGName}"
    echo "Create system log volume for /var/log "
    LVM_Device_Create "sys_lv_log"       "8G"   "${VGName}"
    echo "Create application log volume for /tmp "
    LVM_Device_Create "sys_lv_tmp"       "4G"   "${VGName}"
    echo "Create root srv volume for /srv "
    LVM_Device_Create "lv_srv"           "10G"  "${VGName}"
    echo "Create application common configuration volume for /srv/config "
    LVM_Device_Create "app_lv_config"     "4G" "${_VgName}" 
    echo "Create application data volume for /srv/data "
    LVM_Device_Create "app_lv_data"      "100G" "${VGName}"
    echo "Create application authentification volume for /srv/data/auth "
    LVM_Device_Create "app_lv_data_auth"  "4G" "${_VgName}" 
    echo "Create application common data share volume for /srv/data/share "
    LVM_Device_Create "app_lv_data_share" "20G" "${_VgName}" 
    echo "Create application common sgbd volume for /srv/data/sgbd "
    LVM_Device_Create "app_lv_data_sgbd"  "8G" "${_VgName}"
    echo "Create application common web volume for /srv/data/www "
    LVM_Device_Create "app_lv_data_www"   "10G" "${_VgName}" 
    echo "Create application log volume for /srv/data/run "
    LVM_Device_Create "lv_srv_run"       "20G"  "${VGName}"
    echo "Create application log volume for /srv/container "
    LVM_Device_Create "lv_srv_container" "10G"  "${VGName}"
    echo "Create application log volume for /srv/data/log "
    LVM_Device_Create "app_lv_log"       "8G"   "${VGName}"
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

RebuildNetwork
BuildLvs
init 6