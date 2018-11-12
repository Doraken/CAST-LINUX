#!/bin/bash
###############################################################################
# Info   : Auto-framworkDoc-generator.ksh              Version : 1.1.2.1      #
#                                                                             #
# Creation Date : 18/02/2008                                                  #
# Team          : Only me after all                                           #
# Support mail  : arnaud@crampet.net                                          #
# Author        : Arnaud Crampet                                              #
#                                                                             #
# Subject : This main launch autodocumentation proc that rebluild all xml     #
#           used to display documentation.                                    #
###############################################################################
####
# INFO


Conf_Generics="../conf/generics.cnf"
Conf_Specifics="document.cnf"
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





################# Main

### INIT conf
### Sourcing for all lib and configuration componment

#######################################################


document_get_all_function_names
document_Generate "xml"
document_Generate "MANHTML"

