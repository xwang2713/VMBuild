#!/usr/bin/env python

from __future__ import print_function
import argparse
import logging
import os
import paramiko
import sys

from vmgen.config import Config
from vmgen.scp import SCP
from vmgen.template import Template
from vmgen.generator import Generator
from vmgen.logger import Logger



def main():

    parser = argparse.ArgumentParser("Generate a Vagrant VM Build.")
    parser.add_argument("--template=", dest='template', default='template',
                        help='Template to use for the Build.'
                        )
    parser.add_argument("--dest", dest='dest', default="/tmp",
                        help='The destination to create the Build.'
                        )
    parser.add_argument("--key", dest='key', default="~/.ssh/id_rsa",
                        help='SSH Key to use to get file from staging.'
                        )
    parser.add_argument("--level", dest='level', default="info",
                        help='Set Logging level.'
                        )
    parser.add_argument("--json", dest='HPCCJson', default="HPCCSystemsVM.json",
                        help='Set HPCCSystemVM JSON File.'
                        )
    parser.add_argument("--gm-version", dest='GMVersion', default="",
                        help='Ganglia-monitoring version.'
                        )
    parser.add_argument("--nm-version", dest='NMVersion', default="",
                        help='Nagios-monitoring version.'
                        )
    parser.add_argument("--wssql-version", dest='WSSQLVersion', default="",
                        help='wssql version.'
                        )
    parser.add_argument("version", metavar="VERSION", type=str, default="",
                        help='Version to build.'
                        )
    parser.add_argument("build", metavar="BUILD", type=str, default="",
                        help='Build to locate on staging.'
                        )
    args = parser.parse_args()

    try:
        log = Logger(args.level)

        #Move paramiko logging to WARNINGS+ only.
        if args.level != "debug":
            logging.debug("Setting paramiko logging to WARNING")
            logging.getLogger("paramiko").setLevel(logging.WARNING)
        else:
            logging.debug("Setting paramiko logging to INFO")
            logging.getLogger("paramiko").setLevel(logging.INFO)

        logging.info("Launching VM Build Generation.")
        conf = Config.ConfigFactory_fromJson(args.HPCCJson)
        conf.addConfigItem("template", args.template)
        conf.addConfigItem("dest", args.dest+"/"+args.version)
        conf.addConfigItem("key", os.path.expanduser(args.key))
        conf.addConfigItem("version", args.version)
        conf.addConfigItem("build", args.build)
        if  args.GMVersion :
           conf.addConfigItem("ganglia-monitoring-version", args.GMVersion)

        if  args.NMVersion :
           conf.addConfigItem("nagios-monitoring-version", args.NMVersion)

        if  args.WSSQLVersion :
           conf.addConfigItem("wssql-version", args.WSSQLVersion)
        
        logging.info(getattr(conf, "ganglia-monitoring-version"))
        logging.info(getattr(conf, "nagios-monitoring-version"))
        logging.info(getattr(conf, "wssql-version"))
        gen = Generator.GeneratorFactory(conf)

        #print(temp.txt)

    except Exception as e:
        logging.critical(e)
    except KeyboardInterrupt:
        logging.critical("Keyboard Interrupt Caught.")

if __name__ == "__main__":
    main()
