###############################################################################
# account.lib                                                  Version : 1.0  #
# Author : Arnaud Crampet                                 Date : 00/00/2006   #
# Team          : Only me after all                                           #
# Support mail  : arnaud@crampet.net                                          #
# Author        : Arnaud Crampet       / Arnaud Crampet                       #
#                                                                             #
# Subject : This library provide base access to a Account ations              #
#                                                                             #
###############################################################################
####
# Info

function Account_Exist
{
#|# AE_ACCOUNT_NAME_To_Check     : Use this var so set which account to controle
#|# AE_ACCOUNT_ID_To_Check       : Use this var so set which account to controle
#|# AE_ACCOUNT_Err_Type          : Use this var so set Type Of errore used if account not present
#|# AE_ACCOUNT_Creation          : Use this var to set if you give account name or id
#|# ${1}                         : use this vas to set [ AE_ACCOUNT_To_Check ]
#|# ${2}                         : use this vas to set [ AE_ACCOUNT_Err_Type ]
#|# ${3}                         : use this vas to set [ AE_ACCOUNT_TYPE_INF ]
#|# ${4}                         : use this vas to set [ AE_ACCOUNT_Creation ]
#|#
#|# Base usage  : Account_Exist E_ACCOUNT_NAME_To_Check AE_ACCOUNT_ID_To_Check ACCOUNT_Err_Type ACCOUNT_Creation    
#|#
#|# Description : This function is used to check result of a past action and choose action
#|#
#|# Send Back   : Message / Exit / function#
############ STACK_TRACE_BUILDER #####################
Function_Name="$0"
Function_PATH="${Function_PATH}/${Function_Name}"
######################################################
MSG_DISPLAY "Debug6" "Current Stack : [ ${Function_PATH} ] "

AE_ACCOUNT_NAME_To_Check="${1}"
AE_ACCOUNT_ID_To_Check="${2}"
AE_ACCOUNT_Err_Type="${3}"
AE_ACCOUNT_Creation="${4}"
AE_Account_Home
AE_Account_Shell
AE_Account_Comment


Account_Get_By_Name "${AE_ACCOUNT_NAME_To_Check}" "${AE_ACCOUNT_Err_Type}"
Account_Get_By_id   "${AE_ACCOUNT_ID_To_Check}" "${AE_ACCOUNT_Err_Type}"

set -A AE_ACC_TEST $( cat /etc/passwd | grep "${AE_ACCOUNT_NAME_To_Check}" | awk -F ":" '{print $1 " " $2}' )


if [ "${AE_ACC_TEST[0]}" = "${Account_Get_By_Name}" ]
   then
   	   MSG_DISPLAY "Debug5" "Account [ ${GLOBAL_Name_present} ] : PRESENT "
       if [ "${AE_ACC_TEST[1]}" = "${Account_Get_By_id}" ]
          then
               MSG_DISPLAY "Info" "Account : [ ${Account_Get_By_Name} ] Is ok with id [ ${Account_Get_By_id} ]"
          else
               Account_used_id   "${AE_ACCOUNT_ID_To_Check}" "${AE_ACCOUNT_Err_Type}"

       fi

   else
        echo ""
fi




############### Stack_TRACE_BUILDER ################
Function_PATH="$( dirname ${Function_PATH} )"
####################################################
}


function Account_used_id
{
#|# Var to set  : None
#|# AGBI_ACCOUNT_ID_To_Check                  : Use this var so set which account to controle
#|# AGBI_ACCOUNT_Err_Type                     : Use this var so set Type Of errore used if account not present
#|# ${1}                                      : use this vas to set [ AE_ACCOUNT_To_Check ]
#|# ${2}                                      : use this vas to set [ AE_ACCOUNT_Err_Type ]
#|# Base usage  : Account_Get_By_id "AGBI_ACCOUNT_ID_To_Check" "AGBI_ACCOUNT_Err_Type"
#|#
#|# Description : This function is used to check if an id is used on an account
#|#
#|# Send Back   : Vars  [ GLOBAL_id_present ]
#
############ STACK_TRACE_BUILDER #####################
Function_Name="$0"
Function_PATH="${Function_PATH}/${Function_Name}"
######################################################
MSG_DISPLAY "Debug6" "Current Stack : [ ${Function_PATH} ] "

AGBI_ACCOUNT_ID_To_Check="${1}"
AGBI_ACCOUNT_Err_Type_if_used="${2}"

cat /etc/passwd | awk -F ":" '{ print $3 }' | grep ${AGBI_ACCOUNT_ID_To_Check} > /dev/null
if [ ${?} = "0" ]
    then
    	 Global_info_id_used_state="USED"
         Global_info_id_if_used_ACNAME="$(cat /etc/passwd | awk -F ":" '{ print $1 " " $3}' | grep ${AGBI_ACCOUNT_ID_To_Check} | awk '{ print $1}')"
    else
         Global_info_id_used_state="NOT_USED"
fi
############### Stack_TRACE_BUILDER ################
Function_PATH="$( dirname ${Function_PATH} )"
####################################################
}


function Account_ID_Check
{
#|# ACC_ACCOUNT_To_Check                  : Use this var so set which account to controle
#|# ACC_ACCOUNT_Err_Type                  : Use this var so set Type Of errore used if account not present
#|# ${1}                                 : use this vas to set [ AE_ACCOUNT_To_Check ]
#|# ${2}                                 : use this vas to set [ AE_ACCOUNT_Err_Type ]
#
############ STACK_TRACE_BUILDER #####################
Function_Name="$0"
Function_PATH="${Function_PATH}/${Function_Name}"
######################################################
MSG_DISPLAY "Debug6" "Current Stack : [ ${Function_PATH} ] "


cat /etc/passwd | grep -e ${ACCOUNT_to_check}


############### Stack_TRACE_BUILDER ################
Function_PATH="$( dirname ${Function_PATH} )"
####################################################
}

function Get_Account_list
{
#|# ACC_ACCOUNT_list_RetVal              : Use this var so set Variable name user to send back account liste data
#|# ACC_ACCOUNT_Err_Type                 : Use this var so set Type Of errore used if account not present
#|# ${1}                                 : use this vas to set [ AE_ACCOUNT_To_Check ]
#|# ${2}                                 : use this vas to set [ AE_ACCOUNT_Err_Type ]
#
############ STACK_TRACE_BUILDER #####################
Function_Name="$0"
Function_PATH="${Function_PATH}/${Function_Name}"
######################################################
MSG_DISPLAY "Debug6" "Current Stack : [ ${Function_PATH} ] "

for Accts in $(  cat /etc/passwd | awk -F: '{ print $1 }' ) 
	do 
		AcctTempVar=${Accts};${AcctTempVar}
done 



############### Stack_TRACE_BUILDER ################
Function_PATH="$( dirname ${Function_PATH} )"
####################################################
}


function Create_Account
{
#|# ACC_ACCOUNT_LOGIN                    : Use this var so set account login name to create                      
#|# ACC_ACCOUNT_ID                       : Use this var so set uniq id to tuse for te new account                  
#|# ACC_ACCOUNT_GID                      : Use this var so set primary groupe id to use for account creation     
#|# ACC_ACCOUNT_HOME                     : Use this var so set home directory to use for account creation        
#|# ACC_ACCOUNT_SHELL                    : Use this var so set home directory to use for account creation        
#|# ACC_ACCOUNT_COMMENT                  : Use this var so set Variable name user to send back account liste data
#|# ACC_ACCOUNT_Err_Type                 : Use this var so set Type Of errore used if account not present
#|# ${1}                                 : use this vas to set [ AE_ACCOUNT_LOGIN    ]
#|# ${2}                                 : use this vas to set [ AE_ACCOUNT_ID       ]
#|# ${3}                                 : use this vas to set [ AE_ACCOUNT_GID      ]
#|# ${4}                                 : use this vas to set [ AE_ACCOUNT_HOME     ]
#|# ${5}                                 : use this vas to set [ AE_ACCOUNT_SHELL    ]
#|# ${6}                                 : use this vas to set [ AE_ACCOUNT_COMENT   ]
#|# ${7}                                 : use this vas to set [ AE_ACCOUNT_err_type ]
#|#
#|# BAse usage : Create_Account "mylogin" "user_id" "user_gid" "user_home" "User_COmment" "criticity on fail"
#
############ STACK_TRACE_BUILDER #####################
Function_Name="$0"
Function_PATH="${Function_PATH}/${Function_Name}"
######################################################
MSG_DISPLAY "Debug6" "Current Stack : [ ${Function_PATH} ] "
ACC_ACCOUNT_LOGIN="${1}"            
ACC_ACCOUNT_ID="${2}"          
ACC_ACCOUNT_GID="${3}"         
ACC_ACCOUNT_HOME="${4}"             
ACC_ACCOUNT_SHELL="${5}"                      
ACC_ACCOUNT_COMMENT="${6}"   
ACC_ACCOUNT_Err_Type="${7}"


Empty_Var_Control "${ACC_ACCOUNT_LOGIN}"    "ACC_ACCOUNT_LOGIN"    "Debug"   "4" "Empty login NAme                             " "" ""   
Empty_Var_Control "${ACC_ACCOUNT_ID}"       "ACC_ACCOUNT_ID"       "Debug"   "0" "Empty user  id it will be set automaticaly   " "Create_Account_SUB_ID" ""    
Empty_Var_Control "${ACC_ACCOUNT_GID}"      "ACC_ACCOUNT_GID"      "Debug"   "0" "Empty group id it will be set automaticaly   " "" "" 
Empty_Var_Control "${ACC_ACCOUNT_HOME}"     "ACC_ACCOUNT_HOMME"    "Debug"   "0" "Empty home path it will be set automaticaly  " "Create_Account_SUB_home" ""   
Empty_Var_Control "${ACC_ACCOUNT_SHELL}"    "ACC_ACCOUNT_SHELL"    "Debug"   "0" "Empty Shell type it Will be set as noshell   " "Create_Account_SUB_shell" ""  
Empty_Var_Control "${ACC_ACCOUNT_COMMENT}"  "ACC_ACCOUNT_COMMENT"  "Debug"   "0" "Empty Comment it Will be set as noshell      " "Create_Account_SUB_Comment" ""  
Empty_Var_Control "${ACC_ACCOUNT_Err_Type}" "ACC_ACCOUNT_Err_Type" "Debug"   "4" "Empty error level control                    " "" ""  

useradd -u ${ACC_ACCOUNT_ID} -g ${ACC_ACCOUNT_GID} -d ${ACC_ACCOUNT_HOME} -s ${ACC_ACCOUNT_SHELL} -c "${ACC_ACCOUNT_COMMENT}" -m  ${ACC_ACCOUNT_LOGIN}
CTRL_Result_func "${?}" "Creating user : [ ${ACC_ACCOUNT_LOGIN}] " "Can t create it " "1" 


############### Stack_TRACE_BUILDER ################
Function_PATH="$( dirname ${Function_PATH} )"
####################################################
}


function Create_Account_SUB_home
{
#|# Vars to set : None
#|# 
#|# Base usage :  Create_Account_SUB_home
#|# 
#|# Return : variable named : ACC_ACCOUNT_HOME
############ STACK_TRACE_BUILDER #####################
Function_Name="$0"
Function_PATH="${Function_PATH}/${Function_Name}"
######################################################


ACC_ACCOUNT_HOME=${Base_NuserHome}/${ACC_ACCOUNT_LOGIN}
MSG_DISPLAY "Debug" "New Home set for user ${ACC_ACCOUNT_LOGIN}  : [ ${ACC_ACCOUNT_HOME} ] "



############### Stack_TRACE_BUILDER ################
Function_PATH="$( dirname ${Function_PATH} )"
####################################################
}


function Create_Account_SUB_shell
{
#|# Vars to set : None
#|# 
#|# Base usage :  Create_Account_SUB_shell
#|# 
#|# Return : variable named : ACC_ACCOUNT_SHELL
############ STACK_TRACE_BUILDER #####################
Function_Name="$0"
Function_PATH="${Function_PATH}/${Function_Name}"
######################################################


ACC_ACCOUNT_SHELL="${Base_NoshellUser}"
MSG_DISPLAY "Debug" "New shell set for user ${ACC_ACCOUNT_LOGIN}  : [ ${ACC_ACCOUNT_SHELL} ] "



############### Stack_TRACE_BUILDER ################
Function_PATH="$( dirname ${Function_PATH} )"
####################################################
}



function Create_Account_SUB_ID
{
#|# Vars to set : None
#|# 
#|# Base usage : Create_Account_SUB_ID
#|# 
#|# Return : variable named : ACC_ACCOUNT_ID
############ STACK_TRACE_BUILDER #####################
Function_Name="$0"
Function_PATH="${Function_PATH}/${Function_Name}"
######################################################
ACC_ACCOUNT_SHELL="${Base_NoshellUser}"

cat /etc/passwd  | awk -F[:] '{ print $3 }' | sort -n > ${Base_Dir_Scripts_Tmp}/tmp.file  
for IDS in $(  cat  ${Base_Dir_Scripts_Tmp}/tmp.file ) 
do
	if (( ${IDS} >= ${BASEUIDUSRMIN} && ${IDS} <= ${BASEUIDUSRMAX}  x)) 
	then 
		CCIUD="$(expr  ${IDS} + 1 )"
	fi
done

IDMXTEST=$(expr ${BASEUIDUSRMAX} + 1 )

if  [ ${CCIUD} = ${IDMXTEST} ]
then
	MSG_DISPLAY "ErrorN" "no defaul free UID for user : [ ${ACC_ACCOUNT_LOGIN} ] "
else 
        ACC_ACCOUNT_ID="${CCIUD}"
	MSG_DISPLAY "Debug" "New ID set for user ${ACC_ACCOUNT_LOGIN}  : [ ${ACC_ACCOUNT_ID} ] "
fi

############### Stack_TRACE_BUILDER ################
Function_PATH="$( dirname ${Function_PATH} )"
####################################################
}

function Create_Account_SUB_Comment
{
#|# Vars to set : None
#|# 
#|# Base usage : Create_Account_SUB_Comment
#|# 
#|# Return : variable named : ACC_ACCOUNT_COMMENT
############ STACK_TRACE_BUILDER #####################
Function_Name="$0"
Function_PATH="${Function_PATH}/${Function_Name}"
######################################################
 

ACC_ACCOUNT_COMMENT="Account created on $(date +%Y %m %d %HH %MM) using CAST framwork"
MSG_DISPLAY "Debug" "New comment set for user ${ACC_ACCOUNT_LOGIN}  : [ ${ACC_ACCOUNT_COMMENT} ] "


############### Stack_TRACE_BUILDER ################
Function_PATH="$( dirname ${Function_PATH} )"
####################################################
}



Sourced_OK="1"
