#!/bin/sh 
_Current_ID=$(id | awk '{ print $1}' | awk -F\( '{ print $1 }' | awk -F\= '{ print $2 }')

if [ ${_Current_ID} -eq "0" ] 
  then 
    echo " ----> root ID ok continue ..."
  else 
    echo " You must be root to launch this script ... exiting" 
    exit 4
fi 


function Dir_null_or_slash
{
Path_To_test=${1}

if [ -z "${Path_To_test}" ] 
   then 
   	   MSG_DISPLAY "ErrorN" " Error ON PATH  : [ Value is NULL ]" "1"
   else 
       if [ "${Path_To_test}" = "/" ]
          then 
           	   MSG_DISPLAY "ErrorN" " Error ON PATH  : [ Value is / ]" "1"
      fi
fi
}



function Directory_CRT
{
#|# Base_param_Dir_To_Create    : use this var to set which irectory to control and create
#|# ${1}                        : use this var to set Base_param_Dir_To_Create
#|# Basic usage : 
#|#               Directory_CRT "My_Directory"

############ STACK_TRACE_BUILDER #####################
Function_Name="$0"
Function_PATH="${Function_PATH}/${Function_Name}"
######################################################
MSG_DISPLAY "Debug4" "Current Stack : [ ${Function_PATH} ] "

Base_param_Dir_To_Create="${1}"

Dir_null_or_slash ${Base_param_Dir_To_Create}
MSG_DISPLAY "StMessage" "Checking  directory : [ ${Base_param_Dir_To_Create} ] "
if [ -d "${Base_param_Dir_To_Create}" ]
   then 
	   MSG_DISPLAY "EdSMessage" "Present"
    else 
        mkdir -p ${Base_param_Dir_To_Create}
        Return_code=$?
        if [ "${Return_code}" = "0" ]
           then
        	   MSG_DISPLAY "EdSMessage" "CREATED"
	       else
	    	   MSG_DISPLAY "EdEMessage" "Can't be created"
               MSG_DISPLAY "ErrorN" " can't create directory : [ ${Base_param_Dir_To_Create} ]" "1"
         fi
fi
############### Stack_TRACE_BUILDER ################
Function_PATH="$( dirname ${Function_PATH} )"
####################################################
}
