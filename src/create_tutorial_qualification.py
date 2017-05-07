#! /usr/bin/env python
from boto.mturk.question import Question, QuestionContent, \
        AnswerSpecification, FreeTextAnswer, SimpleField, \
        Overview, FormattedContent, QuestionForm
from traceback import print_exc
#from boto.mturk.qualification import *
#from boto.mturk.connection import *
#from datetime import *
from mturk_util import mkParser, connect
from experiments import Experiment, get_unused_port, start_server, ServerRun
from lib.common.util import error

p = mkParser("Run experiment", True)
p.add_argument('--lvlset', type=str, \
        default='desugared-boogie-benchmarks',
        help='Lvlset to use for serving benchmarks"')

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
              QuestionContent([SimpleField("Text", \
                                           "Please enter the code from" +\
                                           " the last page of the tutorial:")]),
              AnswerSpecification(FreeTextAnswer()),
              True)

def question_form(serverPort):
    o = Overview([FormattedContent(htmlOverview.format(serverPort, CODE_LEN))])
    return QuestionForm([o, q])

try:
    mc = connect(args.credentials_file, args.sandbox)
    balance = mc.get_account_balance()
    print "Balance:", balance[0]

    exp = Experiment(args.ename, True);
    srid = exp.create_unique_server_run_id()
    port = get_unused_port()
    p = start_server(port, args.ename, srid, args.lvlset, "fuzzy")
    print "Started server run", srid, "on port", port, "with pid", p.pid

    r = mc.create_qualification_type("InvGame Tutorial Completed", \
            "Complete the short tutorial to the game",\
            "Active",\
            ["game tutorial", "math", "puzzle"],\
            test = question_form(port), test_duration = 30 * 60);
    assert len(r) == 1
    exp.add_session(ServerRun(srid, r[0].QualificationTypeId, p.pid, port))
    print "Created qualification: ", r[0].QualificationTypeId
except Exception:
    print_exc()
    error("Failed...")
