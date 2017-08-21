<#

.SYNOPSIS
Build HPCC VM Image for VMware from HPCC VirtualBox Image

.DESCRIPTION
This is the top Powershell script to HPCC VM image for VMware

Usage: ./build_vxml.ps1 
          -arch <i386|amd64  If none both i386 and amd64 will be built> 
          -branch <HPCC branch or tag. For example, 5.2.2-1>
          -directory <work directory. The default is c:/tmp/VMs>
          -sikuli_home <sikuli home directory with contains runScript, sikuli-script.jar>

.EXAMPLE
./build_vmx.ps1 -branch 5.2.2-1

.EXAMPLE
./build_vmx.ps1 -arch amd64 -branch 5.4.0-rc1

.NOTES
The output will be transfered to stagging server.

.LINK
https://github.com/xwang2713/VMBuild.git

#>

param(
       $arch="",
       $branch=$(Throw "Missing branch/tag suffix or full name. For example 5.2.2-1"),
       $directory="C:/tmp/VMs",
       $sikuli_home="C:/software/Sikuli"
     )

#-----------------------------------------------------------
# Handle parameters
#-----------------------------------------------------------		
if ( $directory -eq "" )
{
   $directory = "c:/tmp/VMs"
}

if ( ! (Test-Path ${directory}) )
{
   mkdir ${directory} | Out-Null
}

if ( $arch -eq "" )
{
   $arch = "i386", "amd64"
}

rm -r -Force ${directory}/*
$global:version = ${branch}.split("-")[0]
$global:revision = ${branch}.split("-")[1]
"version:$global:version, revision:$global:revision"
$env:SCRIPT_DIR = split-path $myInvocation.MyCommand.path
$global:staging = "hpccbuild@10.240.32.242:/data1/hpcc/builds"


$ssh_key_file = ls ~/.ssh/hpcc_key_pair |  %{$_.FullName} 
$ssh_key_file = $ssh_key_file -replace '\\', '/'

#-----------------------------------------------------------
# For each arch type
#-----------------------------------------------------------
foreach ($one_arch in $arch)
{
    "`nProcess $one_arch"
    $env:VM_DIR = "${directory}/${one_arch}"
    if ( Test-Path $env:VM_DIR )
    {
       rm -r -Force $env:VM_DIR
    }
    mkdir $env:VM_DIR  | Out-Null
    cd $env:VM_DIR
    if ( $one_arch -eq "amd64" )
    {
       $original_ova = "HPCCSystemsVM-amd64-${branch}.ova"
    }
    else
    {
       $original_ova = "HPCCSystemsVM-${branch}.ova"
    }

    "scp -i ${ssh_key_file} ${global:staging}/CE-Candidate-${version}/bin/vm/${original_ova} ."
    scp -i "${ssh_key_file}" ${global:staging}/CE-Candidate-${version}/bin/vm/${original_ova} .
    "Sikuli home: $sikuli_home"
    "${sikuli_home}/runScript.cmd -c -r $env:SCRIPT_DIR/WIN.sikuli/create_vmx_ova.sikuli"
    & "${sikuli_home}\runScript.cmd" -c -r $env:SCRIPT_DIR/WIN.sikuli/create_vmx_ova.sikuli
    scp -i "${ssh_key_file}" work/*.ova ${global:staging}/CE-Candidate-${version}/bin/vm/

    cd $env:SCRIPT_DIR
}	

#C:\cygwin64\home\wangxi01\work\VM_Builds\VMBuild\VMware
