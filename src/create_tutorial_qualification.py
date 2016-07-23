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

args = p.parse_args()

CODE_LEN = "5";

htmlOverview = """
<p>We are developing a new game to aid program verification.
   Your goal in each level is to come up with expressions that are
   accepted by the game. The game requires a short tutorial to play.</p>

<p>
Here is what you need to do concretely to get the qualification:
</p>

<ol>

<li>
Use Google Chrome to navigate to the game tutorial <a target='_blank' href='https://zoidberg.ucsd.edu:{0}/qualification_tutorial.html'> here</a>
</li>

<li>
Play through the short tutorial. Note that the tutorial has 3 easy sample levels spread throughout it.
</li>

<li>
On the last screen you will receive a {1} letter code. Enter it in the question below:
</li>

</ol>

Thank you!"""

q = Question("code",
              QuestionContent([SimpleField("Text", "Please enter the code from the last page of the tutorial:")]),
              AnswerSpecification(FreeTextAnswer()),
              True)

def question_form(port):
    o = Overview([FormattedContent(htmlOverview.format(port, CODE_LEN))])
    return QuestionForm([o, q])

try:
    srid = "tutorial_qualification"
    port = get_unused_port()
    p = start_server(port, srid, "tutorial_server")
    print "Started server run", srid, "on port", port, "with pid", p.pid 

    mc = connect(args.credentials_file, args.sandbox)
    balance = mc.get_account_balance()
    print "Balance:", balance[0]

    r = mc.create_qualification_type("InvGame Tutorial Completed", "Complete the short tutorial to the game", "Active", ["game tutorial", "math", "puzzle"],
            test = question_form(port), test_duration = 30 * 60);
except:
    print_exc()
    error("Failed...")
