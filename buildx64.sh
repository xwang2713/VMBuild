#!/bin/bash
#./generate-vm-template.py --json HPCCSystemsVM64.json --dest ~/VMbuildDir64 4.2.0-rc1 CE-Candidate-4.2.0

./generate-vm-template.py --json HPCCSystemsVMBionic64_HPCC7x.json --dest ../build64 \
--gm-version 7.0.6-1 --nm-version 7.0.0-1 7.2.0-rc2 CE-Candidate-7.2.0
