import logging
import requests

class HTTP(object):
    """docstring for HTTP"""
    def __init__(self, local, remote):
        self.local = local
        self.remote = remote

    def downloadPackage(self):
        logging.info("Downloading [{remote}] to [{local}]".format(
            remote=self.remote,local=self.local
        ))
        r = HTTP.createRequest(self.remote)
        with open(self.local, 'wb') as f:
            for chunk in r.iter_content(chunk_size=1024):
                if chunk:
                    f.write(chunk)
                    f.flush()

    @staticmethod
    def createRequest(url, stream=True`):
        logging.debug("Creating requests get object.")
        return requests.get(url, stream=stream)

    @staticmethod
    def HTTPFactory(config):
        logging.debug("Creating HTTP Object.")
        return HTTP(config.localPackage, config.remotePackage)

