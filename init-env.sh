#!/bin/bash 
_Current_ID=$(id | awk '{ print $1}' | awk -F\( '{ print $1 }' | awk -F\= '{ print $2 }')
_RootDir="/srv/admin/CAST-LINUX"
_LST_PacMan="apt-get yum"
 
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
        echo " ---->  Error ON PATH  : [ Value is NULL ]" "1"
    else 
        if [ "${Path_To_test}" = "/" ]
          then 
                echo " ---->  Error ON PATH  : [ Value is / ]" "1"
        fi
  fi
}



function Directory_CRT
{
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
        	   echo  "CREATED"
	       else
	    	   echo "Can't be created"
               echo " ---->  can't create directory : [ ${Base_param_Dir_To_Create} ]"  
         fi
fi
}


function RaiseFlag()
{
  __Message="${1}"
  if [ ${__Redflag} -eq "0" ]
      then 
           echo " " > /dev/null
      else 
           echo "Fatal error on installation ... " 
           echo "${__Message}"
           exit 1
  fi
}


function installMinimalPackages()
{
case ${__USED_PKGMAN} in 
      yum) yum install ${__Mpackage}          
          ;; 
  apt-get) apt-get install ${__Mpackage}          
          ;;
        *) echo "Fatal error package manager not set properly"
           exit 1          
           ;;
esac 
}


function Main() 
{
echo "Entering to Framework installation tasks"
echo "Creating base root directory"
Directory_CRT "${_RootDir}"
echo "shearching for you package manager"
__Redflag="1"
echo ${_LST_PacMan}
for __Pacman in $( echo ${_LST_PacMan} ) 
   do 
      echo "searching for ${__Pacman}"
      __tmpPacMan=$(which ${__Pacman})
      if [ "${?}" = "0" ]
          then
              echo "Package manager : [ ${__Pacman} ] found at : [ ${__tmpPacMan} ]"
              __USED_PKGMAN="${__Pacman}"
              __Redflag="0"
          else 
              echo "Package manager : [ ${__Pacman} ] Not found"
      fi
done 
RaiseFlag "no package manager found !!!! "

}

 
Main
