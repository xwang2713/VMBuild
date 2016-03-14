from __future__ import print_function
import logging
import os
import shutil

from vmgen.template import Template


class Generator(object):
    """docstring for Generator"""
    def __init__(self, config):
        self.config = config

    def getOptionalPackages(self, xClient):

        for optionalPackage in self.config.optional_packages:

           #print ("optional package", optionalPackage)
           optionalPackageVersion ="{name}-version".format(name=optionalPackage['name'])
           #if (getattr(self.config, optionalPackageVersion) == None):
           #   self.config.addConfigItem("optPackageVersion", self.config.version)
           #else:
           #   self.config.addConfigItem("optPackageVersion", getattr(self.config, optionalPackageVersion))

           if (getattr(self.config, optionalPackageVersion) == None):
              optionalPackage['version']  = self.config.version
           else:
              optionalPackage['version']  = getattr(self.config, optionalPackageVersion)

           self.config.addConfigItem(optionalPackage['packageKey'], 
                self.config.optionalPackage( optionalPackage ))
           
           xClient.get(self.config.optionalRemotePackage(optionalPackage), self.config.dest)
          

    def getPackage(self):
        if self.config.stagingMethod == "ssh":
            from vmgen.scp import SCP
            sClient = SCP.SCPFactory(self.config)
            sClient.get(self.config.remotePackage, self.config.dest)
            self.getOptionalPackages(sClient)
        elif self.config.stagingMethod == "http":
            from vmgen.http import HTTP
            hClient = HTTP.HTTPFactory(self.config)
            hClient.downloadPackage()
            self.getOptionalPackages(hClient)
        elif self.config.stagingMethod == "local":
            pass
        else:
            raise Exception("Invalid stagingMethod [{}]".format(self.stagingMethod))

    def createDest(self):
        if os.path.isdir(self.config.dest):
            logging.info("Removing existing directory [{}]".format(self.config.dest))
            shutil.rmtree(self.config.dest)
        logging.info("Creating directory [{}]".format(self.config.dest))
        os.mkdir(self.config.dest)

    def generateTemplates(self):
        for temp in self.config.templates:
            Template.TemplateFactory(self.config,
                                     self.config.templateFile(temp)
                                     ).write()

    @staticmethod
    def GeneratorFactory(config):
        logging.debug("Creating Generator object.")
        gen = Generator(config)
        gen.createDest()
        gen.getPackage()
        logging.info("Using template directory [{}]".format(config.templateDir))
        gen.generateTemplates()
        return gen
