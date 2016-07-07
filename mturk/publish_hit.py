#! /usr/bin/env python
from argparse import *
from traceback import *
import sys
from boto.mturk.question import *
from boto.mturk.qualification import *
from boto.mturk.connection import *
from datetime import *
from common import error, mkParser, connect


p = mkParser("Publish a HIT for playing the game")
args = p.parse_args()
#### HIT CONTENT
Title = "Play a Math Puzzle Game For Science!"

Max_assignments = 1

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
Use Google Chrome to navigate to <a target='_blank' href='http://zoidberg.ucsd.edu:5000/tutorial_patterns.html'> http://zoidberg.ucsd.edu:5000/tutorial_patterns.html </a>
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

reward = '2.00'

try:
    mc = connect(args.credentials_file, args.sandbox)
    balance = mc.get_account_balance()
    print "Balance:", balance[0]

    o = Overview([FormattedContent(htmlOverview)])
    q1 = Question("upload",
                 QuestionContent([SimpleField("Title", "Screen Recording Upload"),
                                  SimpleField("Text", "Please upload the recording of your screen as you were plaing the game.")]),
                 AnswerSpecification(FileUploadAnswer(1024*1024, 100*1024*1024)),
                 True)

    likert_answ = [("Strongly Agree", "R5"), ("Agree", "R4"), ("Neutral", "R3"), ("Disagree", "R2"), ("Strongly disagree","R1")]

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

    qf = QuestionForm([o, q1, q2, q3, q4, q5, q6])
    mastersQualType = "2ARFPLSP75KLA8M8DH1HTEQVJT3SY6" if args.sandbox else \
                      "2F1QJWKUDD8XADTFD2Q0G6UTO95ALH"

    quals = [] if args.sandbox else [
                        NumberHitsApprovedRequirement("GreaterThanOrEqualTo", 1000), 
                        PercentAssignmentsApprovedRequirement("GreaterThanOrEqualTo", 97), 
                        Requirement(mastersQualType, "Exists")
                      ]

    r = mc.create_hit(question=qf,
                      lifetime=timedelta(7),
                      max_assignments=Max_assignments,
                      title=Title,
                      description=description,
                      keywords=keywords,
                      reward=reward,
                      duration=timedelta(0, 45*60),
                      qualifications=Qualifications(quals))
    assert len(r) == 1
    print "Created HIT ", r[0].HITId
except:
    print_exc()
    error("Failed...")
