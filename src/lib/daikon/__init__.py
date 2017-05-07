from tempfile import NamedTemporaryFile
from subprocess import call, check_output
from lib.daikon.inv_ast import parseExprAst
from os.path import basename

def toDaikonTrace(varz, trace):
  r = "decl-version 2.0\n"
  r += "ppt LoopEntry:::\n"
  r += "ppt-type point\n"
  for v in varz:
    r += "  variable " + v + "\n";
    r += "    var-kind variable\n";
    r += "    dec-type int\n";
    r += "    rep-type int\n";

  r += "\n";
  for row in trace:
    r += "LoopEntry:::\n";
    for (var,val) in zip(varz, row):
      r += var + "\n" + str(val) + "\n1\n"
    r += "\n"
  return r;

def runDaikon(varz, trace, nosuppress=False):
  with NamedTemporaryFile(suffix=".dtrace", delete=False) as dtraceF:
    dtraceF.write(toDaikonTrace(varz,trace));
    dtraceF.flush();
    args = ["java", "daikon.Daikon"]
    if (nosuppress):
      args = args + \
        [ "--config_option",\
         "daikon.inv.filter.ObviousFilter.enabled=false",\
          "--config_option",\
         "daikon.inv.filter.OnlyConstantVariablesFilter.enabled=false",\
          "--config_option",\
         "daikon.inv.filter.ParentFilter.enabled=false",\
          "--config_option",\
         "daikon.inv.filter.SimplifyFilter.enabled=false",\
          "--config_option",\
         "daikon.inv.filter.UnjustifiedFilter.enabled=false",\
          "--config_option",\
         "daikon.inv.unary.scalar.CompleteOneOfScalar.enabled=true",\
          "--config_option",\
         "daikon.inv.unary.sequence.EltRangeInt.Even.enabled=true",\
          "--config_option",\
         "daikon.inv.unary.scalar.Modulus.enabled=true",\
#          "--config_option",\
#         "daikon.inv.unary.scalar.NonModulus.enabled=true",
          "--config_option",\
         "daikon.inv.binary.twoScalar.NumericInt.ZeroTrack.enabled=true",\
          "--config_option",\
         "daikon.inv.unary.scalar.RangeInt.Even.enabled=true",\
        ]
    args.append(dtraceF.name)
    raw = check_output(args)
    call(["rm", basename(dtraceF.name)[:-len(".dtrace")]+".inv.gz"])
    start = raw.index("LoopEntry:::") + len("LoopEntry:::")
    end = raw.index("Exiting Daikon.", start)
    invs = filter(lambda x: x != "",
                  map(lambda x:  x.strip(), raw[start:end].split("\n")))
    # I don't understand how LinearTeranry invariants without justification are
    # displayed... Also getting lazy to fix the long line..
    invs = filter(lambda x: "warning: too few samples for daikon.inv.ternary.threeScalar.LinearTernary invariant" not in x, invs); #pylint: disable=line-too-long
    invs = filter(lambda x: "(mod 0)" not in x, invs);
    try:
      return map(parseExprAst, invs)
    except:
      print invs;
      raise;
