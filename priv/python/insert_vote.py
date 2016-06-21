from utils import get_bigchain, get_node_keys
import time


def insert_vote(candidate_id=400):
    """Insert a vote into the Chain with Bigchain DB
    Args:
        candidate_id (int)
    Returns:
        None
    Raises:
        Exception ...
    """
    connection = get_bigchain()
    keys = get_node_keys()
    payload = {
        'candidate_id': candidate_id,
        'region_id': 0
    }

    # Create transaction uses the operation `CREATE` and has no inputs
    transaction = connection.create_transaction(connection.me, keys.public_key, None, 'CREATE', payload=payload)
    # All transactions need to be signed by the user creating the transaction
    transaction_signed = connection.sign_transaction(transaction, connection.me_private)

    # Write the transaction to the bigchain.
    # The transaction will be stored in a backlog where it will be validated,
    # included in a block, and written to the bigchain
    connection.write_transaction(transaction_signed)
    # print('Procesando...')
    # time.sleep(15)
    # Retrieve a transaction from the bigchain
    # transaction_retrieved = connection.get_transaction(transaction_signed.get('id'))


if __name__ == '__main__':
    insert_vote(500)
