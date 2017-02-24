from tempfile import NamedTemporaryFile
from subprocess import call, check_output, STDOUT
from os.path import dirname, abspath, relpath

MYDIR = dirname(abspath(relpath(__file__)))
CPA_PATH = MYDIR + "/../../../env/third_party/cpa_checker_1.4/CPAchecker-1.4-svcomp16c-unix/"

def runCPAChecker(cppFile, timelimit=100, config="predicateAnalysis-ImpactRefiner-ABEl.properties"):
  contain_assume_def = [ ]
  with NamedTemporaryFile(suffix=".cpp", delete=False) as processedF:
    cpp_args = [ "cpp",
      "-include", MYDIR+"/dummy.h",
      "-D_Static_assert=assert",
      "-D_static_assert=assert",
      "-D__VERIFIER_assert=assert",
      "-D__VERIFIER_assume(a)=assume(a)",
      "-Dassume(a)=if(!(a)) exit(0)",
      "-DLARGE_INT=2147483647",
      cppFile, processedF.name ]

    call(cpp_args);
    print "Original file:", cppFile, "CPP-ed file in ", processedF.name
    args = [ CPA_PATH + "scripts/cpa.sh",
              "-config", CPA_PATH + "config/" + config,
              "-timelimit", str(timelimit),
              "-setprop", "cpa.predicate.nondetFunctions=unknown1,unknown2,unknown3,unknown4,unknown5,random,__VERIFIER_nondet_int,__VERIFIER_nondet_uint",
              processedF.name ]
    raw = check_output(args, stderr=STDOUT);
    lines = raw.split("\n");
    lines = [x for x in lines if not (x.startswith("Running CPAchecker with") or
                                      x.startswith("Using the following resource") or
                                      x.startswith("CPAchecker 1.4-svcomp16c (OpenJDK") or
                                      x.startswith("Using predicate analysis with") or
                                      x.startswith("Using refinement for predicate analysis with") or
                                      x.startswith("Starting analysis ...") or
                                      x.startswith("Stopping analysis ...") or
                                      x.startswith("More details about the verification run") or
                                      len(x.strip()) == 0) ]
    verified = len([x for x in lines if "Verification result: TRUE." in x]) > 0
    return (verified, "\n".join(lines))
