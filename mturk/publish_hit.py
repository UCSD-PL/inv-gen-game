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

htmlOverview = """<p>We are developing a new game to aid program verification. The game consists of a short tutorial, followed by only 5 levels! Your goal in each level is to come up with expressions that are accepted by the game. If the game rejects an expression, it will give you more guidance! </p>

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
Use Google Chrome to navigate to <a target='_blank' href='http://zoidberg.ucsd.edu:5000/tutorial_new.html'> http://zoidberg.ucsd.edu:5000/tutorial_new.html </a>
</li>

<li>
Play through the short tutorial. Note that the tutorial has 6 easy sample levels spread throughout it. <b>You will get 15c bonus for each sample level you pass!</b>
</li>

<li>
Play as far as you can through the 5 actual game levels (these come after the end of the tutorial).<b>You will get 50c bonus for each actual level you pass!</b>
</li>

<li>
Upload the recording(s) of your browser screen, as you were playing the game.
</li>
</ol>

Thank you!"""

reward = '2.00'

try:
    mc = connect(args.credentials_file, args.sandbox)
    balance = mc.get_account_balance()
    print "Balance:", balance[0]

    o = Overview([FormattedContent(htmlOverview)])
    q = Question("upload",
                 QuestionContent([SimpleField("Title", "Screen Recording Upload"),
                                  SimpleField("Text", "Please upload the recording of your screen as you were plaing the game.")]),
                 AnswerSpecification(FileUploadAnswer(1024*1024, 100*1024*1024)),
                 True)

    qf = QuestionForm([o, q])
    mastersQualType = "2ARFPLSP75KLA8M8DH1HTEQVJT3SY6" if args.sandbox else \
                      "2F1QJWKUDD8XADTFD2Q0G6UTO95ALH"

    r = mc.create_hit(question=qf,
                      lifetime=timedelta(7),
                      max_assignments=Max_assignments,
                      title=Title,
                      description=description,
                      keywords=keywords,
                      reward=reward,
                      duration=timedelta(0, 45*60),
                      qualifications=Qualifications([
                        NumberHitsApprovedRequirement("GreaterThanOrEqualTo", 1000), 
                        PercentAssignmentsApprovedRequirement("GreaterThanOrEqualTo", 97), 
                        Requirement(mastersQualType, "Exists")
                      ]))
    assert len(r) == 1
    print "Created HIT ", r[0].HITId
except:
    print_exc()
    error("Failed...")
