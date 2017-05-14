1. Overview

The goal of the game is to find sufficient invariants to verify programs
expressed in Boogie. We derive potentially multiple 'game levels' from each
Boogie program. Levels are organized in levelsets (living under levelsets/).

1. Code organization

All of the code lives under src/

src/lib/boogie - all relevant boogie code - parsing, ast, evaluating
  expressions, predicate transformers, SSA code as well as invariant checking
  (inv_networks.py)

src/lib/common - common utilities

src/lib/cpa_checker - wrapper for running CPAChecker on our levelsets

src/lib/daikon - wrapper for running Daikon on our levelsets. Includes parsing
  daikon invariants

src/lib/invgen - wrapper for running InvGen on our levelsets

src/static - all frontend code. All of the html files live just under
  src/static

src/static/ts - the bulk of the UI code. All of it is written in Typescript

src/server.py - the server file. Contains all of the JSON-RPC entrypoints for
  communicating between the front and back ends.

src/vc_check.py - contains tryAndVerifyLvl - the entry point to attempting to verify
a program. tryAndVerifyLvl takes a set of (potentially unsound) invariants, filters out
the maximal subset of those that can be shown to be sound, and checks if that subset
guarantees the safety of the program. The bulk of the work for that is done in
filterCandidateInvariants and checkInvNetwork in lib/boogie/inv_networks.py

2. Current Game workflow

The current game flow is as follows:

1) User loads the level game.html?mode=X. We currently support 3 modes of play,
corresponding to some gameplays we're experimenting with:

  patterns - don't provide any additional countereaxmples. User wins a level if
    he either finds the right invariants, or comes up with more than 6
    candidate invariants.
  ctrex - provide a counterexample (if the solver gives us one) after every
    invariant. Again user wins if he either comes up with more than 6 candidate
    invariants.
  rounds - the user plays a level like in patterns. He wins the level under the
    same conditions as in the patterns game. However, if he doesn't find the
    right invariant, and the backend can give us counterexamples to all the
    invariants he came up with, we will display the same level again with the
    added counterexamples. From the point of view of the user, it looks like he
    is playing a harder version of the previous level.

2) The frontend calls App.loadNextLvl to get a level. The frontend displays the
data in the TraceWindow window and the game starts 

3) The user tries expressions in the box until he finds an expression E that:
    1) Is a valid JS invariant (as determined by whether we can parse it using Esprima)
    2) Evaluates to a boolean on each row
    3) All the rows are one color

4) Frontend calls App.simplify(E) to get a 'canonical' version E' of E. The
backend uses z3's simplify to normalize E. For example 'x< 5+6' gets normalized
to 'x-11 <= 0'

5) The frontend calls App.isTautology(E') to check if its tautology. We only
accept non-tautologies to prevent users from cheating by trying stuff like
"0=0" for points

6) The frontend calls App.impliedPairs(OldInvs, E') where OldInvs is the list
of all invariants that the user has come up with so far. impliedPairs checks if
any of hte old invariants imply the current invariant. I.e. we don't want the
user to cheat the system by entering weaker invariants. For example, if he
enteres 'x<100' we would prevent him from entering 'x<99'

7) The frontend calls App.tryAndVerify(OldInvs + [E']). tryAndVerify in the backend does:
    1) Takes the union U of OldInvs + [E'] and  any invariants from previous
       users on this level that have not been proven unsound, an

    2) Finds the maximul sound subset S of U (implemented in
       filterCandidateInvariants in lib/boogie/inv_networks.py)

    3) Checks if S guarantees the safety of the program

8) If the program is verified we repeat the process and show the next level. If
the user has come up with more than 6 invariants, we randomly let him we again
to avoid frustration. In the 'rounds' mode, if the user hasn't verified the
level, we may call App.genNextLevel() instead of App.loadNextLevel().
App.genNextLevel() is responsible for just adding counterexamples to the
current level and returning that as a 'new' level.

3. Amazon MTurk use

We run experiments on Amazon MTurk. There are several scripts to manage this:

  - publish_hit.py - create a new HIT on amazon mturk
  - process_logs.py - process all logs for a given experiment, determine how
      much must be paid to people and optionally pay them.
  - wait_for_hits.py - wait for all hits in an experiment to complete and email
      someone 
  - ls_hits.py - list all hits from MTurk
  - ls_assignments.py - list assignments for a given hit

This is the lifecycle of an MTurk experiment

  0) Call publish_hit.py. It:
      1) Launches a new instance of server.py at some port P
      2) Publishes a new hit to MTurk, that has the url of the server on port P
         hardcoded in it.

  1) When a worker accepts the HIT, Amazon loads our page in an iframe.
     Specifically, it first display
     https://<our-address>:P/mturk_landing.html?mode=X... In the query string
     it passes the workerId, assignmentId, hitID and mturkSubmitTo strings.

  2) mturk_landing.html lookups the workerId in our database/history to see if
     this user has played the tutorial. If so, mturk_landing.html redirects to
     game.html?mode=X&workerId=... otherwise it goes to
     tutorial.html?mode=X&workerId=...

  3) If we go to tutorial.html?mode=X... then the user plays the tutorial.
     Depending on the mode X, he may see different parts of the tutorial. (E.g.
     red rows are only shown for mode \in { ctrex, rounds }

  4) At the end of the tutorial, tutorial.html?mode=X... redirects to
     game.html?mode=X...

  5) User plays the game at game.html?mode=X. He has the option to quit at any time.
     As long as he is playing, he is getting the next level that is 1) unsolved and
     2) has the fewest invariants tried so far.

  6) At the end of the game, the user fills out a short survey. The survey
     submits to the url specified in the mturkSubmitTo query string. This is how we
     communicate back to Amazon that the HIT is done.

  7) We run process_logs.py --pay on the server for this experiment.
     process_logs.py computes how much should we bonus the worker, based on the
     logs. For example if the logs show that he has passed 3 levels after the
     first 2 levels, the script will bonus him 3 * 0.75$ extra. process_logs.py
     also changes the status of the assignment to reviewed.

  8) To analyze the result, you can use (and please extend) the
     analyze_experiment.py script.
