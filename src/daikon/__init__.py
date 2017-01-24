from tempfile import NamedTemporaryFile
from subprocess import call, check_output
from inv_ast import parseExprAst
from os.path import basename

def toDaikonTrace(vars, trace):
  r = "decl-version 2.0\n"
  r += "ppt LoopEntry:::\n"
  r += "ppt-type point\n"
  for v in vars:
    r += "  variable " + v + "\n";
    r += "    var-kind variable\n";
    r += "    dec-type int\n";
    r += "    rep-type int\n";

  r += "\n";
  for row in trace:
    r += "LoopEntry:::\n";
    for (var,val) in zip(vars, row):
      r += var + "\n" + str(val) + "\n1\n"
    r += "\n"
  return r;

def runDaikon(vars, trace):
  with NamedTemporaryFile(suffix=".dtrace", delete=False) as dtraceF:
    dtraceF.write(toDaikonTrace(vars,trace));
    dtraceF.flush();
    raw = check_output(["java", "daikon.Daikon", dtraceF.name])
    call(["rm", basename(dtraceF.name)[:-len(".dtrace")]+".inv.gz"])
    start = raw.index("LoopEntry:::") + len("LoopEntry:::")
    end = raw.index("Exiting Daikon.", start)
    invs = filter(lambda x: x != "", map(lambda x:  x.strip(), raw[start:end].split("\n")))
  return map(lambda x:  parseExprAst(x)[0], invs)
