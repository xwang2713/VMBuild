<#

.SYNOPSIS
Create a ova for VMware with ovftool

.DESCRIPTION
This script is called by sikuli script to create ova file

Usage: ./create_ova.ps1 
          -directory <work directory> 
          -hw_version <hardware version. The default is 8>
          

.EXAMPLE
./create_ova.ps1 

.NOTES

.LINK
https://github.com/xwang2713/VMBuild.git

#>
param(
       $directory="",
       $hw_version="8"
     )

$USER_HOME = ls ~/ |  %{$_.FullName} | select-string -pattern "\\Documents$"
$USER_HOME =  split-path $USER_HOME
$USER_HOME =  $USER_HOME -replace '\\', '/'
$LOG = "C:/create_vmx_ova.log"
$HPCC_FILE_PREFIX = "HPCCSystemsVM"

$orig_dir = pwd
#-----------------------------------------------------------
# Preparation
#-----------------------------------------------------------
if ( $directory -eq "" )
{
    $directory = $env:VM_DIR
}


$original_ova_file = ls ${directory}/${HPCC_FILE_PREFIX}*.ova |  %{$_.FullName} 
if ( ! (Test-Path $original_ova_file) )
{
    "Cannot find $original_ova_file"
    exit 1
}


$vm_file_prefix = ls $original_ova_file | %{$_.basename}
$VMWARE_DIR = "${USER_HOME}/Documents/Virtual Machines"
$vmplayer_dir = "${VMWARE_DIR}/$vm_file_prefix"

if ( ! (Test-Path "$vmplayer_dir") )
{
    "`nCannot find ${vmplayer_dir}."
    "Possible VMPlayer import ${original_ova_file} failed.`n"
    exit 1
}

$vm_work_dir = "${directory}/work"
if ( ! (Test-Path "$vm_work_dir") )
{
   mkdir "$vm_work_dir"
}
cd $vm_work_dir
cp ${vmplayer_dir}/${vm_file_prefix}.vmx .

#-----------------------------------------------------------
# Update vmx and build ova
#-----------------------------------------------------------
"${vmplayer_dir}/${vm_file_prefix}.vmx"
"hw_version: $hw_version"
(Get-Content "${vmplayer_dir}/${vm_file_prefix}.vmx") -replace "^\s*virtualhw\.version\s*=.*$", "virtualhw.version = ${hw_version}" `
   | Set-Content ${vmplayer_dir}/${vm_file_prefix}.vmx

if ( Test-Path "${vm_file_prefix}-vmx.ova" )
{
    rm -Force "${vm_file_prefix}-vmx.ova"
}
ovftool "${vmplayer_dir}/${vm_file_prefix}.vmx" "${vm_file_prefix}-vmx.ova"

cd "$orig_dir"