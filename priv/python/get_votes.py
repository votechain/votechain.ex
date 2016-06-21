import rethinkdb as r

from utils import get_bigchain

def get_votes_for_candidate(bigchain, candidate_id):
    cursor = r.table('bigchain').concat_map(lambda doc: doc["block"]["transactions"].filter(lambda transaction: r.expr([400, 600]).contains(transaction["transaction"]["data"]["payload"]["candidate_id"]))).run(bigchain.conn)
    print(cursor)


if __name__ == '__main__':
    connection = get_bigchain()
    get_votes_for_candidate(connection, 400)
