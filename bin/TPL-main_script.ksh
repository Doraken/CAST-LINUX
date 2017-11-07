#!./ksh
################################################################################
# Info   : Tempalte_installer.ksh                      version : 0.1           #
# author : Arnaud Crampet                              Date    : 14/02/2007    #
#                                                                              #
################################################################################
Conf_Generics="../conf/generics.cnf"
Conf_Specifics="dummy"
Return_Path="`pwd`"
Debug_state="6"
Stop_Level="x"
Action_Type="${0}"
####
# PKG defs version of files



################################################
# Base function of the script

################################################

### Sourcing Specifics Configurations Files
echo "" ; echo "" ; echo "" ; echo ""

echo [ Info   :  script  INIT ]

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



#######################################################
#-------------------------------------------------------------------------------
# Command line parameters verification
#-------------------------------------------------------------------------------
MSG_DISPLAY "Info" "${Product_Name} START AT: $(date)"
while getopts "d:P:N:C:F:hBX" option
do
        case $option in
        d) #|# Level of debug 
           Debug_state="${OPTARG}"
           Empty_Var_Control "${Debug_state}"   "Debug_state"   "ErrorN" "0" "Debug_state=0"
           ;;
        F) #|# Parameter File
           Parameter_File="$OPTARG"
		   Empty_Var_Control "${Parameter_File}"   "Parameter_File"       "ErrorN" "0"
           ;;
        h|H) Usage
             exit $RC_OK
             ;;

        * ) MSG_DISPLAY "Debug" "Error : unknown parameter."
            Usage
            exit $RC_KO
        ;;
        esac
done



################# Main

### INIT conf
### Sourcing for all lib and configuration componment

#######################################################


