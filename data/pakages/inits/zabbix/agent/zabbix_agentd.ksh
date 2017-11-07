#!/bin/ksh
###############################################################################
# zabbix_agentd.ksh                                    Version : 1.1.2.5      #
#                                                                             #
# Creation Date : 03/09/2006                                                  #
# Team          : Only me after all                                           #
# Support mail  : arnaud@crampet.net                                          #
# Author        : Arnaud Crampet                                              #
#                                                                             #
# Subject : This scripe launche or stop zabbix agent                          #
#                                                                             #
###############################################################################



function USAGE
{
echo " USE start|stop|restart "
}

function start_zabbix
{
 /exec/products/zabbix/current/bin/zabbix_agentd -c /exec/applis/zabbix/current/conf/zabbix/zabbix_agentd.conf
}


function  stop_zabbix
{
kill $( cat  /exec/products/zabbix/current/logs/zabbix_agentd.pid  )
if [ "$?" = "0" ]
   then
       echo "Zabbix Agent ! STOP"
   else
       for i in $( ps -aux | grep zabbix | grep current | grep agent | egrep -v grep | awk '{print $2}' )
          do
            kill $i
       done
fi
}

case ${1} in
       start) start_zabbix  ;;
        stop)  stop_zabbix  ;;
     restart)  stop_zabbix
               start_zabbix ;;
           *)  USAGE ;;
esac
