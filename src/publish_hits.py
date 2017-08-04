#! /usr/bin/env python
#pylint: disable=line-too-long

from traceback import print_exc
from boto.mturk.question import ExternalQuestion
from boto.mturk.qualification import Qualifications, \
        NumberHitsApprovedRequirement, \
        PercentAssignmentsApprovedRequirement, Requirement
from datetime import timedelta
from mturk_util import connect, mkParser, error
from experiments import Experiment, get_unused_port, start_server, \
        HIT_REWARD, ServerRun

def publish_hit(credentials, isSandbox, ename, num_hits, lvlset, adminToken,
                db, mode, no_ifs, individual, with_new_var_powerup, mc=None,
                email=None, maxlvls=None, colSwap=False):
    title = "Play a Math Puzzle Game For Science!"
    max_assignments = 1

    keywords = "game, math, programming"

    description = """Help us evaluate our verification game InvGen! Each level is structured as a math puzzle, where you try to come up with correct expressions. Your work directly helps with the verification of programs! More specifically, this HIT involves playing at least two non-tutorial levels of our game. Played it before? Come play again! You will bypass the tutorial and get new levels! New player? Come try it out! We aim to pay about $10/hr. More specifically: (a) $1.50 for the HIT, which involves playing the game for at least 2 non-tutorial levels (b) $1.50 bonus for doing the tutorial, which you only do the first time (c) $0.75 bonus for each non-tutorial level you pass beyond two."""

    mastersQualType = "2ARFPLSP75KLA8M8DH1HTEQVJT3SY6" if isSandbox else \
                      "2F1QJWKUDD8XADTFD2Q0G6UTO95ALH"

    quals = [] if isSandbox else\
        [
           NumberHitsApprovedRequirement("GreaterThanOrEqualTo", 1000),
           PercentAssignmentsApprovedRequirement("GreaterThanOrEqualTo", 97),
           Requirement(mastersQualType, "Exists")
        ]

    if mc is None:
      mc = connect(credentials, isSandbox)
    balance = mc.get_account_balance()
    print "Balance:", balance[0]
    exp = Experiment(ename, True)
    print "Running under experiment", ename

    for i in range(num_hits):
        port = get_unused_port()
        srid = exp.create_unique_server_run_id()
        p = start_server(port, ename, srid, lvlset, adminToken, db, email,
            maxlvls, colSwap)
        print "Started server run", srid, "on port", port, "with pid", p.pid
        start_url =\
            "https://zoidberg.ucsd.edu:{0}/mturk_landing.html?mode=" + mode
        if (no_ifs):
            start_url += "&noifs"
        if individual:
            start_url += "&individual=1"
        if with_new_var_powerup:
            start_url += "&nvpower=1"
        q = ExternalQuestion(start_url.format(port), 1024)
        kind = "ExternalQuestion"
        r = mc.create_hit(question=q,
                          lifetime=timedelta(7),
                          max_assignments=max_assignments,
                          title=title,
                          description=description,
                          keywords=keywords,
                          reward=HIT_REWARD,
                          duration=timedelta(0, 45*60),
                          qualifications=Qualifications(quals))
        assert len(r) == 1
        print "Created", kind, "HIT", r[0].HITId
        exp.add_session(ServerRun(srid, r[0].HITId, p.pid, port))
    return exp

if __name__ == "__main__":
    p = mkParser("Run experiment", True)
    p.add_argument('--num_hits', type=int, required=True,
                   help='number of HITs to create')
    p.add_argument('--lvlset', type=str, required=True,
                   help='Lvlset to use for serving benchmarks"')
    p.add_argument('--adminToken', type=str,
                   help='Token to use to login to admin interfaces', required=True)
    p.add_argument('--no-ifs', action='store_const', const=True, default=False,
                   help='Dont teach implication in tutorial or show it ingame')
    p.add_argument('--individual', action='store_true',
                   help='Run in individual mode (levels solved by others don\'t count)')
    p.add_argument('--with-new-var-powerup', action='store_true',
                   help='Enable the new variable powerup')
    p.add_argument('--mode', type=str, default="patterns",
                   help='Game mode to play in. ',
                   choices=["patterns", "ctrex", "rounds"])
    p.add_argument('--db', type=str, required=True,
                   help='The database for the servers to use')
    p.add_argument('--colSwap', action='store_true',
                   help='Enable column swapping')
    p.add_argument('--maxlvls', type=int,
                   help='Maximum number of levels that can be played per HIT')

    args = p.parse_args()

    try:
        publish_hit(args.credentials_file, args.sandbox, args.ename,
                    args.num_hits, args.lvlset, args.adminToken,
                    args.db, args.mode, args.no_ifs, args.individual,
                    args.with_new_var_powerup)
    except Exception:
        print_exc()
        error("Failed...")
