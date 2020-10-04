#!/usr/bin/ksh
################################################################################
# Info   : Arpcom sanity checker                       version : 0.1           #
# author : Arnaud Crampet                              Date    : 06/09/2006    #
#                                                                              #
################################################################################
Conf_Generics="../conf/generics.cnf"
Conf_Specifics=""
Return_Path="$(pwd)" 
Debug_state="9"
Stop_Level="x"
Action_Type="${0}"
####
# PKG defs version of files



################################################
# Base function of the script 

################################################ 

### Sourcing Specifics Configurations Files 
echo "" ; echo "" ; echo "" ; echo "" 

CNF_SRC="0"
. ${Conf_Generics}
if [ "${CNF_SRC}" = "1" ] 
   then
       echo " Sourcing base configuration File : [ OK ] " 
   else
       echo " Sourcing  base configuration File  : [ ERROR ]" 
       exit 1 
fi 
SRC_AUTO

echo "getting specifics configuration"

for Specs in $( ls ${Base_Dir_Scripts_CNF_spec}/ | grep \.cnf ) 
    do 
      Conf_Specifics="${Specs}"
      echo  "${Conf_Specifics}"
      SANITY_CHECK_Base_env_directory_check
      SANITY_CHECK_Check_TMP_Directory
done 

echo ""
echo ""
echo ""
echo ""
echo "" 

MSG_DISPLAY "Info" " Sanity check [ DONE ] "

