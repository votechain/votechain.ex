"""
Transaction payload example:
{
    'candidate_id': 5,
    'district_id': '10',
    'state_id': '10',
    'voter_gender': 'M'
}

TODO: Refactor everything to avoid duplicated code (about 80% of code is duplicated)
"""
import rethinkdb as r

from utils import get_bigchain

def get_votes_by(value, filter='candidate_id'):
    """Calculates total of votes for given filter
    Returns:
        int: number of votes for the given filter i.e.,

        6
    WARNINGS: We don't recommend to use this for region_id,
        since region_id can be duplicated across states
    """
    bigchain = get_bigchain()
    return r.table('bigchain').concat_map(
        lambda doc: doc["block"]["transactions"].filter(
            lambda transaction: transaction["transaction"]["data"]["payload"][filter] == value
        ).map(
            lambda transaction: transaction["transaction"]["data"]["payload"])
    ).count().run(bigchain.conn)


def get_votes_for_candidate_by_region(candidate_id, state_id, region_id):
    """Calculates total of votes for given filter
    Returns:
        int: number of votes for the given filter i.e.,

        6
    """
    bigchain = get_bigchain()
    return r.table('bigchain').concat_map(
        lambda doc: doc["block"]["transactions"].filter(
            lambda transaction: transaction["transaction"]["data"]["payload"]['candidate_id'] == candidate_id and
                transaction["transaction"]["data"]["payload"]['state_id'] == state_id and
                transaction["transaction"]["data"]["payload"]['region_id'] == region_id
        ).map(
            lambda transaction: transaction["transaction"]["data"]["payload"])
    ).count().run(bigchain.conn)


def get_votes_for_region(region_id, state_id):
    """Calculates total of votes for given region and state
    Returns:
        int: number of votes for the desired region i.e.,

        6
    """
    bigchain = get_bigchain()
    return r.table('bigchain').concat_map(
        lambda doc: doc["block"]["transactions"].filter(
            lambda transaction:
                transaction["transaction"]["data"]["payload"]['region_id'] == region_id and
                transaction["transaction"]["data"]["payload"]['state_id'] == state_id
        ).map(
            lambda transaction: transaction["transaction"]["data"]["payload"])
    ).count().run(bigchain.conn)


def get_total_votes(filter='candidate_id'):
    """Calculates total of votes according to filter
    Args:
        bigchain (object): Instance of Bigchain
        filter (str): name of field for group_by
            Available filters are:
                candidate_id
                district_id
                state_id
                voter_gender
    Returns:
        dict: containing all candidates and votes for each one i.e,

        {600: 6, 400: 2}
    """
    bigchain = get_bigchain()
    data = r.table('bigchain').group(
        lambda doc: doc["block"]["transactions"]["transaction"]["data"]["payload"][filter]
    ).count().run(bigchain.conn)

    # Let's clean this ...
    # Because (I don't know why but...) this query returns something like this:
    # {(600,): 6, (): 11, (400,): 2}
    # We need to feed our clients with something smoother
    results = {}
    for k, v in data.items():
        if k and hasattr(k, '__iter__'):
            results[k[0]] = v

    return results

if __name__ == '__main__':
    bigchain = get_bigchain()
    print(get_votes_by(304))  # filter by candidate_id
    print(get_votes_by('09', filter='district_id'))
    print(get_votes_by(31, filter='state_id'))
    print(get_votes_by('F', filter='voter_gender'))
    print(get_votes_for_region('09', 31))
    print(get_votes_for_candidate_by_region(304, 31, '09'))
    print(get_total_votes())