#!/bin/bash

./generate-vm-template.py --json HPCCSystemsVMBionic32_HPCC7x.json --dest ../build32 \
--gm-version 7.0.0-1 --nm-version 7.0.0-1 7.2.0-rc2 CE-Candidate-7.2.0
