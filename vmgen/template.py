from __future__ import print_function
import logging
import os

class Template(object):
    """docstring for Template"""
    def __init__(self, config, fn):
        self.config = config
        self.temp = Template.getfile(fn, False)
        self.file = Template.getfile(fn)
        self.txt = Template.readfile(fn)

    def replaceParam(self, key, value):
        self.txt = self.txt.replace(key, value)

    @property
    def outFile(self):
        return "{dir}/{temp}".format(dir=self.config.dest,
                                     temp=self.file)

    def write(self):
        with open(self.outFile, 'w+') as f:
            logging.info("Generating [{}] from [{}]".format(self.outFile, self.temp))
            f.write(self.txt)
        if self.outFile.find(".sh") != -1:
            os.chmod(self.outFile, 0755)

    @staticmethod
    def getfile(fn, rm=True):
        name = os.path.basename(fn)
        if rm:
            return name.replace(".in", "")
        return name

    @staticmethod
    def readfile(fn):
        with open(fn) as f:
            txt = f.read()
        return txt

    @staticmethod
    def TemplateFactory(config, fn, rep=True):
        logging.debug("Creating Template Object for [{}]".format(fn))
        temp = Template(config, fn)
        if rep:
            for k, v in config.replace.items():
                logging.debug(k + "," + v + "," +  getattr(config, v))
                temp.replaceParam(k, getattr(config, v))
        return temp
