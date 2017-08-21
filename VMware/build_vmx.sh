#!/bin/bash

LOG=/tmp/build_vmx.log
export PS4='+${BASH_SOURCE[1]} ${LINENO}: '
touch  $LOG
exec 2> ${LOG}
set -x


function usage()
{
    cat <<USAGE

    ${PROG_NAME} [-a|--arch <value>] [-b|--branch <value>] [-d|--directory <value>]
                 [-s|--sikuli-home <value>]

      options:  
          -a|--arch: architect to build. i386 or amd64. Without this both will be built
          -b|--branch: branch or tag. For example, 5.2.0-rc2
          -d|--directory: work directory. The default is /tmp/VMs
          -s|--sikuli-home: sikuli home directory which contains runScript, sikuli-script.jar
 

USAGE
}


PROG_NAME=$(basename $0)
#/home/xwang/tmp/HPCCSystemsVM-amd64-5.2.0-rc2.vmx
#virtualhw.version = "11"
HPCC_FILE_PREFIX="HPCCSystemsVM"
work_dir=/tmp/VMs
VMWARE_DIR=~/vmware
build_tag=
all_arch=
staging=hpccbuild@10.240.32.240:/data1/hpcc/builds
sikuli_home=




###############################################
#
# Parse command-line parameters
#
###############################################
TEMP=$(/usr/bin/getopt -o a:b:d:hs: --long ,arch,branch,directory,sikuli-home:,help,reset -n 'build_vmx' -- "$@")
if [ $? != 0 ] ; then echo "Failure to parse commandline." >&2 ; end 1 ; fi
eval set -- "$TEMP"
while true ; do
    case "$1" in
       -a|--arch) all_arch="$2"
            shift 2;;
       -b|--branch) build_tag="$2"
            shift 2;;
       -d|--directory) work_dir="$2"
            shift 2;;
       -h|--help) usage
            shift ;;
       -s|--sikuli-home) sikuli_home="$2"
            shift 2;;
       --) shift; break ;;
       *) echo "wrong param $1" && exit 1
          ;;
    esac
done

if [ -z "$work_dir" ]
then
   if [ -z "$VM_DIR" ]
   then
      work_dir=/tmp/VMs
   else
      work_dir=${VM_DIR}
   fi
fi
if [ ! -d "${work_dir}" ]
then
   echo "Can not find ${work_dir}" 
   exit 1
fi

if [ -z "${build_tag}" ]
then
   echo "Missing build branch/tag}" 
   exit 1
fi

if [ -z "$sikuli_home" ]
then
  if [ -n "$SIKULI_HOME" ]
  then
     sikuli_home=${SIKULI_HOME}
  else
     sikuli_home=~/work/sikuli
  fi
fi

###############################################
#
# Preparation
#
###############################################

[ -z "${all_arch}" ] && all_arch="i386 amd64"

version=${build_tag%%-*}
 
mkdir -p ${work_dir}
rm -rf ${work_dir}/*

SCRIPT_DIR=$(dirname $0)
cd $SCRIPT_DIR
export VMX_SCRIPT_DIR=$(pwd)
cd $SCRIPT_DIR

###############################################
#
# For each arch type
#
###############################################
for arch in $all_arch
do

  echo ""
  echo "process $arch ..."
  mkdir -p ${work_dir}/$arch
  export VM_DIR=${work_dir}/${arch}
  if [ "$arch" = "amd64" ]
  then
     original_ova=HPCCSystemsVM-amd64-${build_tag}.ova
  else
     original_ova=HPCCSystemsVM-${build_tag}.ova
  fi
  scp -i ~/.ssh/hpcc_key_pair ${staging}/CE-Candidate-${version}/bin/vm/${original_ova} ${work_dir}/${arch}/

  ${sikuli_home}/runScript -c -r ${VMX_SCRIPT_DIR}/Linux.sikuli/create_vmx_ova.sikuli 
  scp -i ~/.ssh/hpcc_key_pair  ${work_dir}/$arch/work/*.ova ${staging}/CE-Candidate-${version}/bin/vm/
  
  mv /tmp/create_vmx_ova.log ${work_dir}/${arch}/
done

