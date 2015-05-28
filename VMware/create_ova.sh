#!/bin/bash

LOG=/tmp/create_vmx_ova.log
export PS4='+${BASH_SOURCE[1]} ${LINENO}: '
touch  $LOG
exec 2> ${LOG}
set -x


function usage()
{
    cat <<USAGE

    ${PROG_NAME} [-d|--directory <value>] 

      options:  
          -d|--directory: a work directory contains HPCCSystemsVM*.ova
          -v|--hw-version: minimum hware version to support. The default is 8.

USAGE
}


PROG_NAME=$(basename $0)
#/home/xwang/tmp/HPCCSystemsVM-amd64-5.2.0-rc2.vmx
#virtualhw.version = "11"
HPCC_FILE_PREFIX="HPCCSystemsVM"
work_dir=
VMWARE_DIR=~/vmware
hw_version=8



###############################################
#
# Parse command-line parameters
#
###############################################
TEMP=$(/usr/bin/getopt -o d:h --long directory:,help,reset -n 'create_ova' -- "$@")
if [ $? != 0 ] ; then echo "Failure to parse commandline." >&2 ; end 1 ; fi
eval set -- "$TEMP"
while true ; do
    case "$1" in
       -d|--directory) work_dir="$2"
            shift 2;;
       -h|--help) usage
            shift ;;
       -v|--hw-version) hw_version="$2"
            shift 2;;
       --) shift; break ;;
       *) echo "wrong param $1" && exit 1
          ;;
    esac
done

if [ -z "${work_dir}" ]
then
   if [ -n "$VM_DIR" ]
   then
      work_dir=${VM_DIR}
   else
      work_dir=/tmp/VMs
   fi
fi

if [ ! -d "${work_dir}" ]
then
   echo "Can not find ${work_dir}" 
   exit 1
fi


###############################################
#
# Preparation
#
###############################################
original_ova_file=${work_dir}/${HPCC_FILE_PREFIX}*.ova
if [ ! -e ${original_ova_file} ]
then
   echo "Cannot find ${original_ova_file}"
   exit 1
fi

ova_in=$(basename $(ls ${original_ova_file}))
vm_file_prefix=${ova_in%%.ova}

vmplayer_dir=${VMWARE_DIR}/${vm_file_prefix}
if [ ! -d ${vmplayer_dir} ]
then
   echo ""
   echo "  Cannot find ${vmplayer_dir}."
   echo "  Possible VMPlayer import ${original_ova_file} failed."
   echo ""
   exit 1
fi

vm_work_dir=${work_dir}/work
[ -d ${vm_work_dir} ] && rm -rf ${vm_work_dir} 
mkdir -p ${vm_work_dir}
cd ${vm_work_dir}
cp ${vmplayer_dir}/${vm_file_prefix}.vmx .

###############################################
#
# Update vmx and build ova
#
###############################################

sed -i.bak -e "s/virtualhw.version[[:space:]]*=.*/virtualhw.version = \"${hw_version}\"/" ${vmplayer_dir}/${vm_file_prefix}.vmx 
ovftool ${vmplayer_dir}/${vm_file_prefix}.vmx ${vm_file_prefix}-vmx.ova
chmod 644 ${vm_file_prefix}-vmx.ova
[ -e ${vmplayer_dir}/${vm_file_prefix}.vmx.bak ] &&  rm -rf ovftool ${vmplayer_dir}/${vm_file_prefix}.vmx.bak
