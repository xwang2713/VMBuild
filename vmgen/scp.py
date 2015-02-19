from __future__ import print_function
import logging
from thirdparty.scp import SCPClient
from .ssh import SSH

class SCP(object):
    """docstring for SCP"""
    def __init__(self, sClient):
        self.ssh = sClient
        self.client = SCPClient(self.ssh.transport, socket_timeout=0.5)

    def put(self, files, remote_path='.', recursive=False,
            preserve_times=False):
        files_str = " ".join(files)
        logging.info("Downloading over ssh [{files}] {remote}".format(
            files=files_str, remote=remote_path
        ))
        self.client.put(files, remove_path, recursive, preserve_times)

    def get(self, remote_path, local_path='.', recursive=False,
            preserve_times=False):
        logging.info("scp {remote} {local}".format(remote=remote_path,
                                                   local=local_path
                                                   ))
        self.client.get(remote_path, local_path, recursive, preserve_times)

    @staticmethod
    def SCPFactory(config):
        logging.debug("Creating SCP Object.")
        sClient = SSH.SSHFactory(config)
        return SCP(sClient)
