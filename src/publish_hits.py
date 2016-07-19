#! /usr/bin/env python
from argparse import *
from traceback import *
import sys
from boto.mturk.question import *
from boto.mturk.qualification import *
from boto.mturk.connection import *
from datetime import *
from mturk_util import error, mkParser, connect
from experiments import *

p = mkParser("Run experiment")
p.add_argument('--num_hits', type=int, default=1, help='number of HITs to create')
p.add_argument('--eid', type=int, help='ID for experiment; if none provided, create new experiment')

args = p.parse_args()

title = "Play a Math Puzzle Game For Science!"

max_assignments = 1

keywords = "game, math, programming"

description = "Help us evaluate our verification game InvGen! Each level is structured as a math puzzle, where you try to come up with correct expressions Your work directly helps with the verification of programs!"

htmlOverview = """<p>We are developing a new game to aid program verification. The game consists of a short tutorial, followed by only 5 levels! Your goal in each level is to come up with expressions that are accepted by the game.</p>

<p>
Here is what you need to do concretely:
</p>

<ol>
<li>
Install a free screen recording software of your choice. For example:
<a target='_blank' href='http://screencast-o-matic.com/home'>http://screencast-o-matic.com/home</a>

<br/>
<p> <b> Note: </b> Some free screen recording software has a limit on the length of the video (e.g. 10 min). If you run into this, please split your recording into several smaller videos, then zip them up and upload them as a single ile. </p>
</li>

<li>
Begin recording your screen.
</li>

<li>
Use Google Chrome to navigate to <a target='_blank' href='http://zoidberg.ucsd.edu:{0}/tutorial_patterns.html'> the following link</a>
</li>

<li>
Play through the short tutorial. Note that the tutorial has 3 easy sample levels spread throughout it.
</li>

<li>
Play as far as you can through the 5 actual game levels (these come after the end of the tutorial).<b>You will get 50c bonus for each actual level you pass!</b>
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

def question_form(port):
    o = Overview([FormattedContent(htmlOverview.format(port))])
    return QuestionForm([o, q1, q2, q3, q4, q5, q6, q7])
    #return QuestionForm([q2])

mastersQualType = "2ARFPLSP75KLA8M8DH1HTEQVJT3SY6" if args.sandbox else \
                  "2F1QJWKUDD8XADTFD2Q0G6UTO95ALH"

quals = [] if args.sandbox else [
                    NumberHitsApprovedRequirement("GreaterThanOrEqualTo", 1000), 
                    PercentAssignmentsApprovedRequirement("GreaterThanOrEqualTo", 97), 
                    Requirement(mastersQualType, "Exists")
                  ]

reward = '2.00'

try:
    mc = connect(args.credentials_file, args.sandbox)
    balance = mc.get_account_balance()
    print "Balance:", balance[0]

    if args.eid == None:
        exp = create_new_experiment()
        s = "Created new experiment with id"
    else:
        exp = Experiment(args.eid)
        s = "Using existing experiment with id"
    eid = exp.experiment_id
    print s, eid
    for i in range(args.num_hits):
        port = get_unused_port()
        sid = exp.create_unique_session_id()
        p = start_server(port, eid, sid)
        print "Started server session", sid, "on port", port, "with pid", p.pid 
        r = mc.create_hit(question=question_form(port),
                          lifetime=timedelta(7),
                          max_assignments=max_assignments,
                          title=title,
                          description=description,
                          keywords=keywords,
                          reward=reward,
                          duration=timedelta(0, 45*60),
                          qualifications=Qualifications(quals))
        assert len(r) == 1
        print "Created HIT", r[0].HITId
        exp.add_session(Session(sid,r[0].HITId,p.pid))
except:
    print_exc()
    error("Failed...")
