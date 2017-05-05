from tempfile import NamedTemporaryFile
from subprocess import call, check_output, STDOUT, check_call, \
        CalledProcessError
from os.path import dirname, abspath, relpath
from pydot import graph_from_dot_file
from lib.common.util import unique, error
from z3 import parse_smt2_string
import re

MYDIR = dirname(abspath(relpath(__file__)))
INVGEN_PATH = MYDIR + "/../../../env/third_party/invgen/"

def convertCppFileForInvGen(cppFile, outFile):
  with NamedTemporaryFile(suffix=".cpp", delete=False) as processedF:
    # First strip #includes and add a int NONDET;
    badLinesRe = re.compile("(^#include.*$)|" +
                              "int unknown[0-9]\(\);|" +
                              "int __VERIFIER_nondet_int\(\);|" +
                              "unsigned int __VERIFIER_nondet_uint\(\);|" +
                              "_Bool __VERIFIER_nondet_bool\(\);")
    noNondetIntAssign = re.compile(" *= *__VERIFIER_nondet_int *\(\)")
    noNondetUIntAssign = re.compile(" *= *__VERIFIER_nondet_uint *\(\)")
    substStar = re.compile("while *\( *\* *\)")
    lines = open(cppFile).read().split("\n");
    lines = filter(lambda l:  not badLinesRe.match(l), lines)
    lines = ["//Auto-generated by " + __file__ + " from " + cppFile ] + \
            ["int NONDET;"] + lines;
    lines = [ noNondetIntAssign.sub("",l) for l in lines ]
    lines = [ noNondetUIntAssign.sub("",l) for l in lines ]
    lines = [ substStar.sub("while(NONDET)",l) for l in lines ]
    processedF.write("\n".join(lines))
    processedF.flush();

    error("De-included file in ", processedF.name)
    cpp_args = [ "cpp",
      "-D_Static_assert=assert",
      "-D_static_assert=assert",
      "-Dstatic_assert=assert",
      "-D__VERIFIER_assert=assert",
      "-D__VERIFIER_assume=assume",
      "-Dunknown1()=NONDET",
      "-Dunknown2()=NONDET",
      "-Dunknown3()=NONDET",
      "-Dunknown4()=NONDET",
      "-Dunknown5()=NONDET",
      "-DLARGE_INT=2147483647",
      "-D__VERIFIER_nondet_int()=NONDET",
      processedF.name, outFile ]

    call(cpp_args, stderr=STDOUT);
    error("CPP-ed file in ", outFile)

def runInvGen(cppFile, mainRoutine):
  with NamedTemporaryFile(suffix=".front.out", delete=False) as frontOut,\
       NamedTemporaryFile(suffix=".invgen.out", delete=False) as invgenOut,\
       NamedTemporaryFile(suffix=".pl", delete=False) as transitionsF:
    args = [ INVGEN_PATH + "/frontend",
              "-main", mainRoutine,
              cppFile,
              "-o", transitionsF.name]
    error("Frontend output in ", frontOut.name)
    try:
      check_call(args, stderr=STDOUT, stdout=frontOut);
    except CalledProcessError,e:
      raw = open(frontOut.name).read();
      outp = raw.split("\n")
      if outp[-2] == "Fatal error: exception ArmcStmt.NotImplemented(\"Mod\")":
        return ("NYI: Mod", [], outp)
      elif "Fatal error:" in raw and "Not implemented (unsigned int" in raw:
        return ("NYI: Unsigned Int Cast", [], outp)
      elif outp[-2] == "Fatal error: exception Failure(\"Push Negation failed! I am here!\")": #pylint: disable=line-too-long
        return ("Frontend Crash", [], outp)
      raise e
    
    error("Transitions file in ", transitionsF.name)
    args = [ INVGEN_PATH + "/invgen", transitionsF.name]
    error("Invgen output in ", invgenOut.name)
    try:
      raw = check_output(args, stderr=STDOUT);
    except CalledProcessError,e:
      outp = e.output.split("\n");
      if outp[-2] == "! 'All direct(loop free) path to error are unsat'":
        return ("InvGen Crash", [], outp);
      elif outp[-2] == "! pred2coeff('Bad Predicate')":
        return ("InvGen Crash", [], outp);
      raise e;
    lines = raw.split("\n");

    while (lines[-1] == ''):
        lines.pop()

    solved = lines[-1].startswith("#Total Solving time:")
    invgenOut.write("\n".join(lines));
    invgenOut.flush();
    if (solved):
      invRe = re.compile("^[^\[]*\[(?P<invs>[^\]]*)\]$")
      invariants = invRe.match(lines[-2]).groupdict()["invs"].split(",")
    else:
      invariants = []

    return (solved, invariants, lines)
