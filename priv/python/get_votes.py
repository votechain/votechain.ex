import rethinkdb as r
​
from utils import get_bigchain
​
def get_votes_for_candidate(bigchain, candidate_id):
    """Calculates total of votes for given candidate"""
    return r.table('bigchain').concat_map(
        lambda doc: doc["block"]["transactions"].filter(
            lambda transaction: transaction["transaction"]["data"]["payload"]["candidate_id"] == candidate_id
        ).map(
            lambda transaction: transaction["transaction"]["data"]["payload"])
    ).count().run(bigchain.conn)
​
​
def get_total_votes(bigchain):
    """Calculates total of votes per candidate"""
    data = r.table('bigchain').group(lambda doc: doc["block"]["transactions"]["transaction"]["data"]["payload"]["candidate_id"]).count().run(bigchain.conn)
​
    # Let's clean this ...
    # Because (I don't know why but...) this query returns something likes this:
    # {(600,): 6, (): 11, (400,): 2}
    # We need to feed our clients with something smoother
    results = {}
    for k, v in data.items():
        if k and hasattr(k, '__iter__'):
            results[k[0]] = v
​
    return results
​
if __name__ == '__main__':
    connection = get_bigchain()
    print(get_votes_for_candidate(connection, 500))
    print(get_total_votes(connection))