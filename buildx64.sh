#!/bin/bash
#./generate-vm-template.py --json HPCCSystemsVM64.json --dest ~/VMbuildDir64 4.2.0-rc1 CE-Candidate-4.2.0

./generate-vm-template.py --json HPCCSystemsVMTrusty64_HPCC7x.json --dest ../build64 \
--gm-version 6.5.0-trunk0 --nm-version 6.5.0-trunk0 \
6.5.0-trunk0 CE-Candidate-6.5.0
