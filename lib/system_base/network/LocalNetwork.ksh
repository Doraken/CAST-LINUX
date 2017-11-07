###############################################################################
#  LocalNetwork.lib                                     Version : 1.0         #
#                                                                             #
# Creation Date : 18/02/2016                                                  #
# Team          : only me                                                     #
# Support mail  : arnaud@crampet.net                                          #
# Author        : Arnaud Crampet                                              #
#                                                                             #
# Subject : This library provide base runtime to manag local inet interfaces  #
#                                                                             #
###############################################################################
####
# INFO 



function Get_ETH0_IPV4
{
#|# Var to set  : None
#|#
#|# Base usage  : Get_ETH0_IPV4
#|#
#|# Description : This function get eth0 inet ipv4 adrresse and store it into global var
#|#
#|# Send Back   : var named ETH0_IPV4
############ STACK_TRACE_BUILDER #####################
Function_Name="$0"
Function_PATH="${Function_PATH}/${Function_Name}"
######################################################
MSG_DISPLAY "Debug6" "Current Stack : [ ${Function_PATH} ] "

ETH0_IPV4=$(ifconfig eth0 | grep "inet " | awk '{ print $2 }')
MSG_DISPLAY "Debug6" "Current ETH0 Ip V4 : [ ${ETH0_IPV4} ] "


############### Stack_TRACE_BUILDER ################
Function_PATH="$( dirname ${Function_PATH} )"
####################################################
}

function Get_ETH1_IPV4
{
#|# Var to set  : None
#|#
#|# Base usage  : Get_ETH0_IPV4
#|#
#|# Description : This function get eth0 inet ipv4 adrresse and store it into global var
#|#
#|# Send Back   : var named ETH0_IPV4
############ STACK_TRACE_BUILDER #####################
Function_Name="$0"
Function_PATH="${Function_PATH}/${Function_Name}"
######################################################
MSG_DISPLAY "Debug6" "Current Stack : [ ${Function_PATH} ] "

ETH1_IPV4=$(ifconfig eth1 | grep "inet " | awk '{ print $2 }')
MSG_DISPLAY "Debug6" "Current ETH1 Ip V4 : [ ${ETH1_IPV4} ] "


############### Stack_TRACE_BUILDER ################
Function_PATH="$( dirname ${Function_PATH} )"
####################################################
}


function Get_ETH0_IPV6
{
#|# Var to set  : None
#|#
#|# Base usage  : Get_ETH0_IPV6
#|#
#|# Description : This function get eth0 inet ipv6 adrresse and store it into global var
#|#
#|# Send Back   : var named ETH0_IPV6
############ STACK_TRACE_BUILDER #####################
Function_Name="$0"
Function_PATH="${Function_PATH}/${Function_Name}"
######################################################
MSG_DISPLAY "Debug6" "Current Stack : [ ${Function_PATH} ] "

ETH0_IPV6=$(ifconfig eth0 | grep "inet6" | awk '{ print $2 }')
MSG_DISPLAY "Debug6" "Current ETH0 Ip V6 : [ ${ETH0_IPV6} ] "


############### Stack_TRACE_BUILDER ################
Function_PATH="$( dirname ${Function_PATH} )"
####################################################
}

function Get_ETH1_IPV6
{
#|# Var to set  : None
#|#
#|# Base usage  : Get_ETH0_IPV6
#|#
#|# Description : This function get eth0 inet ipv6 adrresse and store it into global var
#|#
#|# Send Back   : var named ETH0_IPV6
############ STACK_TRACE_BUILDER #####################
Function_Name="$0"
Function_PATH="${Function_PATH}/${Function_Name}"
######################################################
MSG_DISPLAY "Debug6" "Current Stack : [ ${Function_PATH} ] "

ETH1_IPV4=$(ifconfig eth1 | grep "inet6" | awk '{ print $2 }')
MSG_DISPLAY "Debug6" "Current ETH1 Ip V6 : [ ${ETH1_IPV6} ] "


############### Stack_TRACE_BUILDER ################
Function_PATH="$( dirname ${Function_PATH} )"
####################################################
}

function Dummy_function
{
#|# Var to set  : None
#|#             : Use this var to set 
#|#             : Use this var to set 
#|# ${1}        : Use this var to set [  ]                
#|# ${2}        : Use this var to set [  ]               
#|#
#|# Base usage  : None
#|#
#|# Description : None
#|#
#|# Send Back   : None
############ STACK_TRACE_BUILDER #####################
Function_Name="$0"
Function_PATH="${Function_PATH}/${Function_Name}"
######################################################
MSG_DISPLAY "Debug6" "Current Stack : [ ${Function_PATH} ] "

MSG_DISPLAY "Info" "this is a model function"

############### Stack_TRACE_BUILDER ################
Function_PATH="$( dirname ${Function_PATH} )"
#################################################### 
}

Sourced_OK="1"  
