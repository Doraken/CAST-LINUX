###############################################################################
# FS.lib                                                Version : 1.1.2.2     #
#                                                                             #
# Creation Date : 02/17/2007                                                  #
# Team          : Only me after all                                           #
# Support mail  : arnaud@crampet.net                                          #
# Author        : Arnaud Crampet                                              #
#                                                                             #
# Subject : This library provide base file system check and stat              #
#                                                                             #
###############################################################################
####
# INFO

function FS_List_local
{
#|#  Basic usage       : FS_List_local
############ STACK_TRACE_BUILDER #####################
Function_Name="${0}"
Function_PATH="${Function_PATH}/${Function_Name}"
######################################################
MSG_DISPLAY "Debug4" "Current Stack : [ ${Function_PATH} ] "
system_counter "init"
for FS_see in $(df -P | grep dev | egrep -v "none" | awk '{print $1}')
  do
  	system_counter
    Counted_FS="${External_Return_Counter}"
    FS_Name_list_tmp="${FS_Name_list_tmp} ${FS_see}"
done
FS_Max=${Counted_FS}
set -A FS_Name_list $( printf -- ${FS_Name_list_tmp} )

############### Stack_TRACE_BUILDER ################
Function_PATH="$( dirname ${Function_PATH} )"
####################################################
}

function FS_Get_all_Full_Stats
{
#|# Var to set  :
#|# FS_Name_list : array list of FS
#|#
#|# Base usage  :  S_Get_all_Full_Stats "Aray_List_FS"
#|#
#|# Description : This function is used to get stats for all File system Mega
#|#               octet and report for a gloab usage of disk space and get FS by
#|#               FS stats
#|#
#|# Send Back   : Global disk usage and fs by fs usag
############ STACK_TRACE_BUILDER #####################
Function_Name="${0}"
Function_PATH="${Function_PATH}/${Function_Name}"
######################################################
MSG_DISPLAY "Debug4" "Current Stack : [ ${Function_PATH} ] "
system_counter "init"


for FS_To_Get_INFS in $(print ${FS_Name_list[@]} )
  do
  	FS_Get_all_stats "${FS_To_Get_INFS}"
  	MSG_DISPLAY "Debug6"  "Working on FS : [ ${FS_To_Get_INFS} ]"
    Total_Size_list_base="${Total_Size_list_base} ${External_FS_Size_Mo_Result}"
    Free_Size_List_Base="${Free_Size_List_Base} ${External_FS_Free_Mo_Result}"
    Used_Size_liste_Base="${Used_Size_liste_Base} ${External_FS_Used_Mo_Result}"
done

set -A FS_SIZE_ARRAY       $( print ${Total_Size_list_base} )
set -A FS_FREE_SIZE_ARRAY  $( print ${Free_Size_List_Base}  )
set -A FS_USED_SIZE_ARRAY  $( print ${Used_Size_liste_Base} )

############### Stack_TRACE_BUILDER ################
Function_PATH="$( dirname ${Function_PATH} )"
####################################################
}

function FS_See_USED_Total
{
#|# Var to set  : None
#|#
#|# Base usage  :  FS_See_USED_Total
#|#
#|# Description : This function is used to get stats for all File system Mega
#|#               octet and report for a gloab usage of disk space
#|#
#|# Send Back   : Global disk usage
############ STACK_TRACE_BUILDER #####################
Function_Name="${0}"
Function_PATH="${Function_PATH}/${Function_Name}"
######################################################
MSG_DISPLAY "Debug4" "Current Stack : [ ${Function_PATH} ] "

FS_Get_all_Full_Stats
Last_CALC_USED="0"

for FS_Calc_used_CACL in $(print ${FS_USED_SIZE_ARRAY[@]} )
  do
  	CALC_USED="$( expr ${Last_CALC_USED} + ${FS_Calc_used_CACL})"
    Last_CALC_USED="${CALC_USED}"
done
USED_TOTAL=${Last_CALC_USED}

for FS_Calc_Free_CACL in $(print ${FS_FREE_SIZE_ARRAY[@]} )
  do
  	CALC_Free="$( expr ${Last_CALC_Free} + ${FS_Calc_Free_CACL})"
    Last_CALC_Free="${CALC_Free}"
done
FREE_TOTAL=${Last_CALC_Free}

for FS_Calc_SIZE_CACL in $(print ${FS_SIZE_ARRAY[@]} )
  do
  	CALC_SIZE="$( expr ${Last_CALC_Free} + ${FS_Calc_Size_CACL})"
    Last_CALC_SIZE="${CALC_SIZE}"
done
SIZE_TOTAL=${Last_CALC_SIZE}

MSG_DISPLAY "Info" "File Sytem TOTAL Size : [ ${SIZE_TOTAL} Mo ] Used : [ ${USED_TOTAL} Mo ] Free : [ ${FREE_TOTAL} Mo ] "
############### Stack_TRACE_BUILDER ################
Function_PATH="$( dirname ${Function_PATH} )"
####################################################
}



function FS_Get_all_stats
{
#|# Var to set  :
#|# FSAS_Name_To_Use : Use this var to set
#|# ${1}        : Use this var to set [ FSAS_Name_To_Use ]
#|#
#|# Base usage  :  FS_Get_all_stats "FS_Name"
#|#
#|# Description : This function is used to get all File system stat in Mega octet
#|#
#|# Send Back   : Fs Used/free/total size in Mo
############ STACK_TRACE_BUILDER #####################
Function_Name="${0}"
Function_PATH="${Function_PATH}/${Function_Name}"
######################################################
MSG_DISPLAY "Debug4" "Current Stack : [ ${Function_PATH} ] "

FSAS_Name_To_Use="${1}"
Empty_Var_Control "${FSAS_Name_To_Use}" "FSAS_Name_To_Use" "ErrorN" "2"

FS_Get_Used_Mo "${FSAS_Name_To_Use}"
FS_Get_Free_Mo "${FSAS_Name_To_Use}"
FS_Get_Size_Mo "${FSAS_Name_To_Use}"

MSG_DISPLAY "Info" "File Sytem ${FSAS_Name_To_Use} Size : [ ${External_FS_Used_Mo_Result} Mo ] Used : [ ${External_FS_Used_Mo_Result} Mo ] Free : [ ${External_FS_Free_Mo_Result} Mo ] "

############### Stack_TRACE_BUILDER ################
Function_PATH="$( dirname ${Function_PATH} )"
####################################################
}

function FS_Get_Used_Mo
{
#|# Var to set  :
#|# FSUM_Name_To_Use : Use this var to set
#|# ${1}        : Use this var to set [ FSUM_Name_To_Use ]
#|#
#|# Base usage  :  FS_Get_Used_Mo "FS_Name"
#|#
#|# Description : This function is used to get used File system size in Mega octet
#|#
#|# Send Back   : Fs Used size in Mo
############ STACK_TRACE_BUILDER #####################
Function_Name="${0}"
Function_PATH="${Function_PATH}/${Function_Name}"
######################################################
MSG_DISPLAY "Debug4" "Current Stack : [ ${Function_PATH} ] "


FSUM_Name_To_Use="${1}"
Empty_Var_Control "${FSUM_Name_To_Use}" "FSUM_Name_To_Use" "ErrorN" "2"

FSUM_Used_Base="$(df -P ${FSUM_Name_To_Use} | grep ${FSUM_Name_To_Use} | awk '{print $3}')"
FSUM_Used_Mo_Result="$( expr  ${FSUM_Used_Base} \/ 1024 )"

MSG_DISPLAY "Debug6" "Resulte of Used space for ${FSFM_Name_To_Use} : [ ${FSFM_Free_Mo_Result} ]"

External_FS_Used_Mo_Result="${FSUM_Used_Mo_Result}"
############### Stack_TRACE_BUILDER ################
Function_PATH="$( dirname ${Function_PATH} )"
####################################################
}

function FS_Get_Free_Mo
{
#|# Var to set  :
#|# FSFM_Name_To_Use : Use this var to set
#|# ${1}        : Use this var to set [ FSFM_Name_To_Use ]
#|#
#|# Base usage  :  FS_Get_Free_Mo "FS_Name"
#|#
#|# Description : This function is used to get free File system size in Mega octet
#|#
#|# Send Back   : Fs free size in Mo
############ STACK_TRACE_BUILDER #####################
Function_Name="${0}"
Function_PATH="${Function_PATH}/${Function_Name}"
######################################################
MSG_DISPLAY "Debug4" "Current Stack : [ ${Function_PATH} ] "


FSFM_Name_To_Use="${1}"
Empty_Var_Control "${FSFM_Name_To_Use}" "FSFM_Name_To_Use" "ErrorN" "2"

FSFM_Free_Base="$(df -P ${FSFM_Name_To_Use} | grep ${FSFM_Name_To_Use} | awk '{print $4}')"
FSFM_Free_Mo_Result="$( expr  ${FSFM_Free_Base} \/ 1024 )"
MSG_DISPLAY "Debug6" "Resulte of free space for ${FSFM_Name_To_Use} : [ ${FSFM_Free_Mo_Result} ]"

External_FS_Free_Mo_Result="${FSFM_Free_Mo_Result}"
############### Stack_TRACE_BUILDER ################
Function_PATH="$( dirname ${Function_PATH} )"
####################################################
}

function FS_Get_Size_Mo
{
#|# Var to set  :
#|# FSGS_Name_To_Use : Use this var to set
#|# ${1}        : Use this var to set [ FSGS_Name_To_Use ]
#|#
#|# Base usage  :  FS_Get_Size_Mo "FS_Name"
#|#
#|# Description : This function is used to get File system size in Mega octet
#|#
#|# Send Back   : Fs size in Mo
############ STACK_TRACE_BUILDER #####################
Function_Name="${0}"
Function_PATH="${Function_PATH}/${Function_Name}"
######################################################
MSG_DISPLAY "Debug4" "Current Stack : [ ${Function_PATH} ] "


FSGS_Name_To_Use="${1}"
Empty_Var_Control "${FSGS_Name_To_Use}" "FSGS_Name_To_Use" "ErrorN" "2"

FSGS_Size_Base="$(df -P ${FSGS_Name_To_Use} | grep ${FSGS_Name_To_Use} | awk '{print $2}')"
FSGS_Size_Mo_Result="$( expr  ${FSGS_Size_Base} \/ 1024 )"

MSG_DISPLAY "Debug6" "Resulte of Size for ${FSFM_Name_To_Use} : [ ${FSFM_Free_Mo_Result} ]"

External_FS_Size_Mo_Result="${FSGS_Size_Mo_Result}"
############### Stack_TRACE_BUILDER ################
Function_PATH="$( dirname ${Function_PATH} )"
####################################################
}

function FS_check_if_present
{
#|# Var to set  :
#|# FSGS_Name_To_Use : Use this var to set
#|# ${1}        : Use this var to set [ FSGS_Name_To_Use ]
#|#
#|# Base usage  :  FS_check_if_present "FS_Name"
#|#
#|# Description : This function is used to check FS is present
#|#
#|# Send Back   : Fs status 
############ STACK_TRACE_BUILDER #####################
Function_Name="${0}"
Function_PATH="${Function_PATH}/${Function_Name}"
######################################################
MSG_DISPLAY "Debug4" "Current Stack : [ ${Function_PATH} ] "


FSGS_Name_To_Use="${1}"
Empty_Var_Control "${FSGS_Name_To_Use}" "FSGS_Name_To_Use" "ErrorN" "2"

df ${FSGS_Name_To_Use} 2> /dev/null
CTRL_Result_func "${?}" "FS check on mount point : [ ${FSGS_Name_To_Use}] " "Can t find it " "1" 


External_FS_Size_Mo_Result="${FSGS_Size_Mo_Result}"
############### Stack_TRACE_BUILDER ################
Function_PATH="$( dirname ${Function_PATH} )"
####################################################
}

function FS_Build_Catalog 
{
#|# Var to set  :
#|#                No var to set 
#|# Base usage  :  FS_Build_Catalog  
#|#
#|# Description : This function is used to File system catalog information.
#|#
#|# Send Back   : File system catalog in /srv/admin/data/catalogue/FileSystem.cat
############ STACK_TRACE_BUILDER #####################
Function_Name="${0}"
Function_PATH="${Function_PATH}/${Function_Name}"
######################################################
MSG_DISPLAY "Debug4" "Current Stack : [ ${Function_PATH} ] "

File_Ctrl_Exist "${Base_FS_catalogue}" "Create_File" "0"  ""  ""
df -h | awk '{ print $1 "|" $6 "|" $5  }'  > ${Base_FS_catalogue} 


External_FS_Size_Mo_Result="${FSGS_Size_Mo_Result}"
############### Stack_TRACE_BUILDER ################
Function_PATH="$( dirname ${Function_PATH} )"
####################################################		
	
}

function FS_DISPLAY_Catalog 
{
#|# Var to set  :
#|#                No var to set 
#|# Base usage  :  FS_Build_Catalog  
#|#
#|# Description : This function is used to File system catalog information.
#|#
#|# Send Back   : File system catalog in /srv/admin/data/catalogue/FileSystem.cat
############ STACK_TRACE_BUILDER #####################
Function_Name="${0}"
Function_PATH="${Function_PATH}/${Function_Name}"
######################################################
MSG_DISPLAY "Debug4" "Current Stack : [ ${Function_PATH} ] "

File_Ctrl_Exist "${Base_FS_catalogue}" "Create_File" "2"  ""  ""
df -h | awk '{ print $1 "|" $6 "|" $5  }'  > ${Base_FS_catalogue} 


External_FS_Size_Mo_Result="${FSGS_Size_Mo_Result}"
############### Stack_TRACE_BUILDER ################
Function_PATH="$( dirname ${Function_PATH} )"
####################################################		
	
}



Sourced_OK="1"
