import os
from collections import namedtuple

from bigchaindb import Bigchain


def get_bigchain():
    return Bigchain()

def get_node_keys():
    KeyPair = namedtuple('KeyPair', ['private_key', 'public_key'])
    return KeyPair(
        private_key=os.getenv('VOTECHAIN_NODE_PRIVATE_KEY'),
        public_key=os.getenv('VOTECHAIN_NODE_PUBLIC_KEY')
    )