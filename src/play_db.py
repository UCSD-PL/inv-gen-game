from json import loads, dumps
from js import esprimaToBoogie
from datetime import datetime
from models import open_sqlite_db, Source, Event, workers, done_tutorial,\
    finished_levels, found_invs, experiments
import sys;

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print "Usage: <db_file>"

    s = open_sqlite_db(sys.argv[1])()

    for w in workers(s):
        print w.name, done_tutorial(w), len(list(w.events)), experiments(w)
        print "Finished lvls: "
        for lvl in finished_levels(w):
            print "   ", lvl

        print "Found invs: "
        for inv in found_invs(w):
            print "   ", inv
