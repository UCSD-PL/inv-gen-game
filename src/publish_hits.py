#! /usr/bin/env python
#pylint: disable=line-too-long

from traceback import print_exc
from boto.mturk.question import Question, QuestionContent, SimpleField, \
        AnswerSpecification, FileUploadAnswer, SelectionAnswer, \
        FreeTextAnswer, Overview, FormattedContent, QuestionForm, \
        ExternalQuestion
from boto.mturk.qualification import Qualifications, \
        NumberHitsApprovedRequirement, \
        PercentAssignmentsApprovedRequirement, Requirement
from datetime import timedelta
from mturk_util import connect, mkParser, error
from experiments import Experiment, get_unused_port, start_server, \
        HIT_REWARD, ServerRun

p = mkParser("Run experiment", True)
p.add_argument('--num_hits', type=int, default=1, \
        help='number of HITs to create')
p.add_argument('--ext', action='store_const', const=True, default=False, \
        help='if specified run ExternalQuestion')
p.add_argument('--lvlset', type=str, default = 'desugared-boogie-benchmarks', \
        help='Lvlset to use for serving benchmarks"')
p.add_argument('--adminToken', type=str, \
        help='Token to use to login to admin interfaces', required=True)
p.add_argument('--no-ifs', action='store_const', const=True, default=False, \
        help='Dont teach implication in tutorial or show it ingame')
p.add_argument('--with-new-var-powerup', action='store_true',
        help='Enable the new variable powerup')
p.add_argument('--mode', type=str, default="patterns", \
        help='Game mode to play in. ', choices=["patterns", "ctrex", "rounds"])
p.add_argument('--db', type=str, default=None,
        help='If specified, an explicit database for the servers to use')

args = p.parse_args()

title = "Play a Math Puzzle Game For Science!"

max_assignments = 1

keywords = "game, math, programming"

description = "Help us evaluate our verification game InvGen! Each level is structured as a math puzzle, where you try to come up with correct expressions. Your work directly helps with the verification of programs! More specifically, this HIT involves playing at least two non-tutorial levels of our game. Played it before? Come play again! You will bypass the tutorial and get new levels! New player? Come try it out! We aim to pay about $10/hr. More specifically: (a) $1.50 for the HIT, which involves playing the game for at least 2 non-tutorial levels (b) $1.50 bonus for doing the tutorial, which you only do the first time (c) $0.75 bonus for each non-tutorial level you pass beyond two."


htmlOverview = """
<p>We are developing a new game to aid program verification.
   The game consists of a short tutorial, followed by 5 levels.
   Your goal in each level is to come up with expressions that are
   accepted by the game. If you have already played this game in a previ
   please don't accept the current HIT. At this point we are looking for 
   new players.</p>

<p>
Here is what you need to do concretely:
</p>

<ol>
<li>
Install a free screen recording software of your choice. For example:
<a target='_blank' href='http://screencast-o-matic.com/home'>http://screencast-o-matic.com/home</a>

<br/>
<p> <b> Note: </b> Some free screen recording software has a limit on the length of the video (e.g. 10 min).
        If you run into this, please split your recording into several smaller videos, then zip them up and upload them as a single file. </p>
</li>

<li>
Begin recording your screen.
</li>

<li>
Use Google Chrome to navigate to <a target='_blank' href='https://zoidberg.ucsd.edu:{0}/tutorial.html?mode=""" + args.mode + ("&noifs" if args.no_ifs else "") + """'> the following link</a>
</li>

<li>
Play through the short tutorial. Note that the tutorial has 3 easy sample levels spread throughout it.
</li>

<li>
Play as far as you can through the 5 actual game levels (these come after the end of the tutorial).<b>You will get 25c bonus for each actual level you pass!</b>
</li>

<li>
Upload the recording(s) of your browser screen, as you were playing the game.
</li>

<li>
Fill out the questionaire below, which asks for your feedback.
</li>

</ol>

Thank you!"""

q1 = Question("upload",
              QuestionContent([SimpleField("Title", "Screen Recording Upload"),
                              SimpleField("Text", "Please upload the recording of your screen as you were plaing the game.")]),
              AnswerSpecification(FileUploadAnswer(1024*1024, 100*1024*1024)),
              True)

likert_answ = [("Strongly Agree", "5"), ("Agree", "4"), ("Neutral", "3"), ("Disagree", "2"), ("Strongly disagree", "1")]

q2 = Question("fun",
              QuestionContent([SimpleField("Title", "Questionaire"),
                              SimpleField("Text", "The game was fun to play. Select the option that is closest to your feelings:")]),
              AnswerSpecification(SelectionAnswer(1, 1, "radiobutton", likert_answ)),
              True)

q3 = Question("challenging",
              QuestionContent([SimpleField("Text", "The game was challenging. Select the option that is closest to your feelings:")]),
              AnswerSpecification(SelectionAnswer(1, 1, "radiobutton", likert_answ)),
              True)

q4 = Question("likes",
              QuestionContent([SimpleField("Text", "What did you like about the game?")]),
              AnswerSpecification(FreeTextAnswer()),
              True)

q5 = Question("dislikes",
              QuestionContent([SimpleField("Text", "What did you find confusing about the game?")]),
              AnswerSpecification(FreeTextAnswer()),
              True)

q6 = Question("suggestions",
              QuestionContent([SimpleField("Text", "Do have any suggestions on how to improve the game? If so, what are they?")]),
              AnswerSpecification(FreeTextAnswer()),
              True)

q7 = Question("experience",
              QuestionContent([SimpleField("Text", "So we can calibrate our results, please describe what programming experience you've had, in particular what programming languages you've used and for how long. If no programming experience, just say None.")]),
              AnswerSpecification(FreeTextAnswer()),
              True)

def question_form(aPort):
    o = Overview([FormattedContent(htmlOverview.format(aPort))])
    return QuestionForm([o, q1, q2, q3, q4, q5, q6, q7])
    #return QuestionForm([q2])

mastersQualType = "2ARFPLSP75KLA8M8DH1HTEQVJT3SY6" if args.sandbox else \
                  "2F1QJWKUDD8XADTFD2Q0G6UTO95ALH"

quals = [] if args.sandbox else [
                    NumberHitsApprovedRequirement("GreaterThanOrEqualTo", 1000),
                    PercentAssignmentsApprovedRequirement("GreaterThanOrEqualTo", 97),
                    Requirement(mastersQualType, "Exists")
                ]

try:
    mc = connect(args.credentials_file, args.sandbox)
    balance = mc.get_account_balance()
    print "Balance:", balance[0]

    exp = Experiment(args.ename, True)
    print "Running under experiment", args.ename
    for i in range(args.num_hits):
        port = get_unused_port()
        srid = exp.create_unique_server_run_id()
        p = start_server(port, args.ename, srid, args.lvlset, args.adminToken, args.db)
        print "Started server run", srid, "on port", port, "with pid", p.pid
        if args.ext:
            start_url = "https://zoidberg.ucsd.edu:{0}/mturk_landing.html?mode=" + args.mode
            if (args.no_ifs):
                start_url += "&noifs"
            if args.with_new_var_powerup:
                start_url += "&nvpower=1"
            q = ExternalQuestion(start_url.format(port), 1024)
            kind = "ExternalQuestion"
        else:
            q = question_form(port)
            kind = "QuestionForm"
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
except Exception:
    print_exc()
    error("Failed...")
