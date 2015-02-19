from __future__ import print_function
import logging
import os
import re
import simplejson as json


class Config(object):
    """docstring for Config"""
    def __init__(self, config):
        """initialize by passing in a dictionary repr of the config"""
        self.config = config

    def addConfigItem(self, name, value):
        self.config[name] = value

    def __getattr__(self, name):
        try:
            return self.config[name]
        except KeyError:
            return None

    def logging(self, logger):
        self.logger = logger

    @property
    def name(self):
        return "{baseName}-{version}".format(baseName=self.baseName,
                                             version=self.version
                                             )

    @property
    def package(self):
        return "{base}_{version}{post}".format(base=self.packageBase,
                                              version=self.version,
                                              post=self.packagePost,
                                              )

    def optionalPackage(self, optPackageObj):
        return "{base}-{version}{post}".format(base=optPackageObj['packageBase'],
                                              version=optPackageObj['version'],
                                              post=self.packagePost,
                                              )

    @property
    def configDir(self):
        return "{dir}".format(dir=os.path.abspath(os.path.curdir))


    @property
    def templateDir(self):
        return "{dir}/{template}".format(dir=os.path.abspath(os.path.curdir),
                                         template=self.template
                                         )
    def templateFile(self, temp):
        return "{dir}/{temp}".format(dir=self.templateDir, temp=temp)


    @property
    def localPackage(self):
        return "{dest}/{package}".format(dest=self.dest, package=self.package)

    @property
    def remotePackage(self):
        if self.stagingMethod == "http":
            return "http://{staging}/builds/{build}/bin/platform/{package}".format(
                    staging=self.staging,
                    build=self.build,
                    package=self.package
                    )
        elif self.stagingMethod == "ssh":
            return "{dir}/{build}/bin/platform/{package}".format(
                    dir=self.buildDir,
                    build=self.build,
                    package=self.package
                    )
        elif self.stagingMethod == "local":
            return "file://{dir}/{build}/bin/platform/{package}".format(
                    dir=self.buildDir,
                    build=self.build,
                    package=self.package
                    )
        else:
            raise Exception("Invalid stagingMethod [{}]".format(self.stagingMethod))

    def optionalRemotePackage(self, optPackage):
        # Currently only handle package inside {build}. 
        # In future if the package outside {build} we can add another tag, for exmaple, standalone:true
        # so imageDir will be relative to {staging}/builds/. but it properly requires a version passed
        # from commmand-line.

        packageRootDir = self.build
        if 'packageRootDir' in optPackage.keys():
           packageRootDir = optPackage['packageRootDir']
           if packageRootDir.endswith("-"):
              VERSION_PATTERN = r'(.*)-[^-]+$' 
              m = re.search(VERSION_PATTERN, optPackage['version'])
              if m:
                 packageRootDir = packageRootDir + m.group(1)  
              else:
                 packageRootDir = packageRootDir + self.version  
            
       
        if self.stagingMethod == "http":
            return "http://{staging}/builds/{build}/{packageDir}/{package}".format(
                    staging=self.staging,
                    build=packageRootDir,
                    packageDir=optPackage['packageDir'],                 
                    package=self.optionalPackage(optPackage)
                    )
        elif self.stagingMethod == "ssh":
            return "{dir}/{build}/{packageDir}/{package}".format(
                    dir=self.buildDir,
                    build=packageRootDir,
                    packageDir=optPackage['packageDir'],                 
                    package=self.optionalPackage(optPackage)
                    )
        elif self.stagingMethod == "local":
            return "file://{dir}/{build}/{packageDir}/{package}".format(
                    dir=self.buildDir,
                    build=packageRootDir,
                    packageDir=optPackage['packageDir'],                 
                    package=self.optionalPackage(optPackage)
                    )
        self.config[optPackage['packageKey']] = self.optionalPackage(optPackage)
    

    @staticmethod
    def loadJson(fp):
        with open(fp) as f:
            return json.load(f)

    @staticmethod
    def ConfigFactory_fromJson(jsonFile):
        logging.info("Creating Config obect from [{}]".format(jsonFile))
        config = Config.loadJson(jsonFile)
        # preprocess optional package: list, etc 
        # set option package file name for replace
        return Config(config)
