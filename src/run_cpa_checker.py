#! /usr/bin/env python
import argparse
from levels import loadBoogieLvlSet
from vc_check import tryAndVerifyLvl
from lib.cpa_checker import runCPAChecker, convertCppFileForCPAChecker
from lib.boogie.z3_embed import to_smt2, z3_expr_to_boogie, Unknown
from lib.common.util import error
from shutil import move, rmtree
# from signal import signal , SIGALRM,  alarm
from threading import Timer
from os.path import exists


def handler():
    # def handler(signum):
    #  assert (signum == SIGALRM)
    raise Exception("timeout")


# signal(SIGALRM, handler);

def verify_solution(loopInvs, lvlName, lvl, time_limit):
    error("z3 invs: ", len(loopInvs), loopInvs)
    try:
        t = Timer(time_limit, handler)
        t.start()
        # alarm(args.time_limit)
        # On lvl d-14 for example the invariants explode exponentially due to
        # inlining of lets. So add timeout. Seems to be the only level with
        # this problem
        invs = map(z3_expr_to_boogie, loopInvs)
    except Exception, e:
        invs = None
        if (e.message == "timeout"):
            conf_status = "timeout"
        else:
            for i in loopInvs:
                error(to_smt2(i))
            conf_status = "verification error: converting invariants to Boogie"
    finally:
        # alarm(0)
        t.cancel()
    if (invs != None):
        try:
            (overfitted, nonind, sound, violations) = \
                tryAndVerifyLvl(lvl, set(invs), set(), time_limit,
                                addSPs=True, generalizeUserInvs=True)

            error("Out of ", invs, "sound: ", sound)

            if (len(violations) > 0):
                error("Supposedly sound inv: ", invs)
                error("Level ", lvlName, "false claimed to be sound!")
                error("Raw output: ", rawOutput)
                conf_status = False
            else:
                conf_status = True
        except Exception, e:
            conf_status = "verification error: " + e.value
    return conf_status;


if (__name__ == "__main__"):
    p = argparse.ArgumentParser(description="run CPAChecker on a levelset")
    p.add_argument('--lvlset', type=str,
                   help='Path to lvlset file', required=True)
    p.add_argument('--csv-table', action="store_true",
                   default=True, help='Print results as a csv table')
    p.add_argument('--time-limit', type=int, default=10,
                   help='Time limit for CPAChecker')
    p.add_argument('--waitEnter', action="store_true",
                   default=False, help='Wait for user to perss Enter before continuing (great for debug)')
    p.add_argument('--config', type=str,
                   help='configuration file to use for CPA Checker\n(properties files under config in CPA checker folder)',
                   required=False)
    p.add_argument('--allConfigs', action="store_true",
                   default=False, help='loops on all configs for CPA Checker')
    args = p.parse_args()
    if args.waitEnter:
        input("Press Enter to continue...")
    lvlSetName, lvls = loadBoogieLvlSet(args.lvlset)

    res = {}
    conf = {}

    for lvlName, lvl in lvls.iteritems():
        cppFile = lvl["path"][1]
        preprocessedFile = cppFile + ".cpachecker.preprocessed"
        error("Running ", lvlName)

        if (not exists(preprocessedFile)):
            convertCppFileForCPAChecker(cppFile, preprocessedFile)

        if args.allConfigs:
            allConfigs = ["apronAnalysis-proofcheck.properties", "apronAnalysis.properties",
                          "apronAnalysis-refiner.properties", "bddAnalysis-concurrency.properties",
                          "bddAnalysis-nospec.properties", "bddAnalysis.properties", "bmc-induction.properties",
                          "bmc-invgen.properties", "bmc.properties", "CBMC.properties", "chc.properties",
                          "combinations-bdd+impact.properties", "combinations-bdd+pred.properties",
                          "combinations-bdd+va.properties", "combinations-value100+pred-cmc.properties",
                          "combinations-valueItp+pred.properties",
                          "correctness-witnesses-k-induction--overflow.properties",
                          "correctness-witnesses-k-induction.properties",
                          "correctness-witness-validation-overflow.properties",
                          "correctness-witness-validation.properties", "deadlock-detection.properties",
                          "defuse.properties", "detectRecursion.properties", "deterministicVariables.properties",
                          "formula-slicing-invariants.properties", "formula-slicing-k-induction.properties",
                          "formula-slicing.properties", "formula-slicing-w-predicate.properties",
                          "generateCFA.properties", "impactAlgorithm-SBE.properties",
                          "intervalAnalysisARG-propertycheck.properties", "intervalAnalysis-bam-rec.properties",
                          "intervalAnalysis-join.properties", "intervalAnalysis.properties",
                          "interval-propertycheck.properties", "invariantGeneration-no-out-no-typeinfo.properties",
                          "invariantGeneration-no-out.properties", "invariantGeneration.properties",
                          "lddAnalysis.properties", "ldv-bam.properties", "ldv.properties", "liveVariables.properties",
                          "lpi-svcomp16.properties", "octagonAnalysis-float.properties",
                          "octagonAnalysis-mergeJoin-cexCheck.properties", "octagonAnalysis-mergeJoin.properties",
                          "octagonAnalysis-mergeWidening-cexCheck.properties",
                          "octagonAnalysis-mergeWidening.properties",
                          "octagonAnalysis.properties", "octagonAnalysis-refiner-float.properties",
                          "octagonAnalysis-refiner-int.properties", "octagonAnalysis-refiner.properties",
                          "octagonAnalysis-restart-float.properties", "octagonAnalysis-restart-int.properties",
                          "paBackwards-debug.properties", "policy-intervals.properties", "policy-invariants.properties",
                          "policy-k-induction.properties", "policy-mathsat.properties", "policy-predicates.properties",
                          "policy.properties", "policy-refinement.properties", "policy-slicing-invariants.properties",
                          "policy-slicing.properties", "policy-value.properties",
                          "predicateAnalysisBackward.properties",
                          "predicateAnalysis-bam-auxiliaryPredicates.properties",
                          "predicateAnalysis-bam-nested-LBE.properties", "predicateAnalysis-bam-nested-SBE.properties",
                          "predicateAnalysis-bam-noPointer.properties", "predicateAnalysis-bam.properties",
                          "predicateAnalysis-bam-rec-plain.properties", "predicateAnalysis-bitprecise.properties",
                          "predicateAnalysis-find-null-deref.properties", "predicateAnalysis-heaparray.properties",
                          "predicateAnalysis-ImpactAbstractionRefiner-ABEl.properties",
                          "predicateAnalysis-ImpactGlobalRefiner-ABEl.properties",
                          "predicateAnalysis-ImpactRefiner-ABEl-bitprecise.properties",
                          "predicateAnalysis-ImpactRefiner-ABElf.properties",
                          "predicateAnalysis-ImpactRefiner-ABEl.properties",
                          "predicateAnalysis-ImpactRefiner-SBE.properties", "predicateAnalysis-invRefiner.properties",
                          "predicateAnalysis-pathExploration.properties",
                          "predicateAnalysis-PredAbsRefiner-ABEl-bitprecise.properties",
                          "predicateAnalysis-PredAbsRefiner-ABElf-bitprecise.properties",
                          "predicateAnalysis-PredAbsRefiner-ABElf.properties",
                          "predicateAnalysis-PredAbsRefiner-ABEl.properties",
                          "predicateAnalysis-PredAbsRefiner-SBE.properties", "predicateAnalysis-proofcheck.properties",
                          "predicateAnalysis-proofcheck-states.properties", "predicateAnalysis-proofgen.properties",
                          "predicateAnalysis.properties", "predicateAnalysis-RefinementSelection-ABE.properties",
                          "predicateAnalysis-RefinementSelection-SBE.properties",
                          "predicateAnalysis-ToleranceConstraintsExtraction-PLUS.properties",
                          "predicateAnalysis-with-invariants.properties",
                          "predicatedAnalysis-bitprecise-Interval.properties", "predicatedAnalysis-Interval.properties",
                          "predicatedAnalysis-Sign.properties", "predicatedAnalysis-Uninit.properties",
                          "predicatedAnalysis-Value.properties", "reachingdefinitionARG.properties",
                          "reachingdefinitionNoLocation.properties", "reachingdefinition.properties",
                          "reachingdef-valueARG.properties", "reachingdef-value.properties",
                          "signAnalysisARG-propertycheck.properties", "signAnalysis.properties",
                          "signAnalysis-propertycheck.properties", "sign-intervalARG.properties",
                          "sign-interval.properties", "smg-label.properties", "smg-ldv.properties", "smg.properties",
                          "smg-with-valueAnalysis.properties",
                          "smg-with-valueAnalysis-without-malloc-failure.properties",
                          "sv-comp12-bam-funpoint.properties", "sv-comp12-bam.properties", "sv-comp12.properties",
                          "sv-comp13--combinations.properties", "sv-comp13--valueItp-pred.properties",
                          "sv-comp14-challenge.properties", "sv-comp14--memorysafety.properties",
                          "sv-comp14.properties",
                          "sv-comp15--memorysafety.properties", "sv-comp15.properties", "sv-comp16-bam.properties",
                          "sv-comp16--k-induction-overflow.properties", "sv-comp16--k-induction.properties",
                          "sv-comp16--memorysafety.properties", "sv-comp16--overflow.properties",
                          "sv-comp16.properties",
                          "uninitVars.properties", "valueAnalysis-bam.properties", "valueAnalysis-bam-rec.properties",
                          "valueAnalysis-BDD-bool-3600s.properties", "valueAnalysis-BDD-bool-intEQ-intADD.properties",
                          "valueAnalysis-BDD-bool-intEQ.properties", "valueAnalysis-BDD-bool.properties",
                          "valueAnalysis-Cegar-Optimized.properties", "valueAnalysis-Cegar.properties",
                          "valueAnalysis-ConcreteCounterexampleCheck.properties",
                          "valueAnalysis-concurrency.properties",
                          "valueAnalysis-featureVars.properties", "valueAnalysis-GlobalRefiner.properties",
                          "valueAnalysis-ItpRefiner-ABElf.properties", "valueAnalysis-ItpRefiner-ABEl.properties",
                          "valueAnalysis-ItpRefiner.properties", "valueAnalysis-java.properties",
                          "valueAnalysis-java-with-RTT.properties", "valueAnalysis-join.properties",
                          "valueAnalysis-no-cex-check.properties", "valueAnalysis-NoRefiner.properties",
                          "valueAnalysis-pcc-trac-allARG.properties", "valueAnalysis-pcc-trac-all.properties",
                          "valueAnalysis-Plain.properties",
                          "valueAnalysis-proofcheck-multiedges-defaultprop.properties",
                          "valueAnalysis-proofcheck.properties", "valueAnalysis.properties",
                          "valueAnalysis-symbolic-Cegar.properties", "valueAnalysis-symbolic-java.properties",
                          "valueAnalysis-symbolic.properties", "valueAnalysis-symbolic-refiner-pred.properties",
                          "valueAnalysis-thresholds.properties", "valuePredicateAnalysis-bam.properties",
                          "valuePredicateAnalysis-bam-rec_bounded.properties",
                          "valuePredicateAnalysis-bam-rec.properties", "weakestPrecondition.properties",
                          "witness-check.properties", "witness-validation--memorysafety.properties",
                          "witness-validation--overflow.properties",
                          "witness-validation-predicateAnalysis-bitprecise.properties", "witness-validation.properties",
                          "witness-validation--recursive.properties", "witness-validation-valueAnalysis.properties"]
            for config in allConfigs:
                res[lvlName + "-" + config] = runCPAChecker(preprocessedFile, args.time_limit, config)
                solved, loopHeaderLbl, loopInvs, rawOutput = res[lvlName + "-" + config]
                if (solved and loopInvs != None):
                    conf[lvlName + "-" + config] = verify_solution(loopInvs, lvlName, lvl,
                                                                   args.time_limit)  # if (args.csv_table):
                elif loopInvs == None:
                    conf[lvlName + "-" + config] = "No Invariants"
                else:
                    conf[lvlName + "-" + config] = "N/A"
                print "Level", lvlName, "solved: ", solved, " by ", config, " confirmed?: ", conf[
                    lvlName + "-" + config]
        else:
            if (args.config == None):
                res[lvlName] = runCPAChecker(preprocessedFile, args.time_limit)
            else:
                res[lvlName] = runCPAChecker(preprocessedFile, args.time_limit, args.config)

            rmtree("tmp_outputs/" + lvlName + "", True)
            try:
                move("output", "tmp_outputs/" + lvlName + "")
            except Exception, e:
                error("Error moving output dir" + e.message)

            solved, loopHeaderLbl, loopInvs, rawOutput = res[lvlName]
            if (solved and loopInvs != None):
                conf[lvlName] = verify_solution(loopInvs, lvlName, lvl, args.time_limit)  # if (args.csv_table):
            elif loopInvs == None:
                conf[lvlName] = "No Invariants"
            else:
                conf[lvlName] = "N/A"
            print "Level", lvlName, "solved: ", solved, "confirmed?: ", conf[lvlName]

if (args.csv_table):
    if (args.csv_table):
        print "Level,Solved,Confirmed"
    for lvlName in res:
        print lvlName, ",", res[lvlName][0], ",", conf[lvlName] if conf.has_key(lvlName) else "N/A"
