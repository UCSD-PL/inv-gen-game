#! /usr/bin/env python
from argparse import *
from traceback import *
import sys
from boto.mturk.question import *
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

htmlOverview = """<p>We are developing a new game to study the potential for human intelligence to help with program verification tasks. The game consists of a short tutorial, followed by only 5 levels! Your goal in each level is to come up with expressions that are accepted by the game. If the game rejects an expression, it will give you more guidance! Here is what you need to do concretely:</p>

<ol>
<li>
Install a free screen recording software of your choice. For example:
<a href='http://screencast-o-matic.com/home'>http://screencast-o-matic.com/home</a>
</li>

<li>
Begin recording your screen
</li>

<li>
Use Google Chrome to navigate to http://zoidberg.ucsd.edu:5000/tutorial_new.html
</li>

<li>
Play through the short tutorial
</li>

<li>
Play as far as you can through the 5 game levels.
</li>

<li>
Upload the recording of your browser screen, as you were playing the game.
</li>
</ol>

Thank you!"""

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

    r = mc.create_hit(question=qf,
                      lifetime=timedelta(7),
                      max_assignments=Max_assignments,
                      title=Title,
                      description=description,
                      keywords=keywords,
                      reward='0.01',
                      duration=timedelta(0, 45*60))
    assert len(r) == 1
    print "Created HIT ", r[0].HITId
except:
    print_exc()
    error("Failed...")
