import subprocess;
import os
import re;
import sys
from boogie_bb import get_bbs
from boogie_loops import loops

ROOT = "/home/dimo/work/inv-gen-game/"
BOOGIE_PATH= "/home/dimo/install/boogie/Binaries/Boogie.exe"

raw_files = [
    ROOT+"dilig-benchmarks/28.boogie",
    ROOT+"dilig-benchmarks/15.boogie",
    ROOT+"dilig-benchmarks/17.boogie",
    ROOT+"dilig-benchmarks/02.boogie",
    ROOT+"dilig-benchmarks/03.boogie",
    ROOT+"dilig-benchmarks/25.boogie",
    ROOT+"dilig-benchmarks/12.boogie",
    ROOT+"dilig-benchmarks/34.boogie",
    ROOT+"dilig-benchmarks/19.boogie",
    ROOT+"dilig-benchmarks/01.boogie",
    ROOT+"dilig-benchmarks/05.boogie",
    ROOT+"dilig-benchmarks/06.boogie",
    ROOT+"ice-benchmarks/trex3.boogie",
    ROOT+"ice-benchmarks/cegar1.boogie",
    ROOT+"ice-benchmarks/countud.boogie",
    ROOT+"ice-benchmarks/add.boogie",
    ROOT+"ice-benchmarks/fig9.boogie",
    ROOT+"ice-benchmarks/multiply.boogie",
    ROOT+"ice-benchmarks/cggmp.boogie",
    ROOT+"ice-benchmarks/matrixl1.boogie",
    ROOT+"ice-benchmarks/sum3.boogie",
    ROOT+"ice-benchmarks/sum4c.boogie",
    ROOT+"ice-benchmarks/sum1.boogie",
    ROOT+"ice-benchmarks/array_diff.boogie",
    ROOT+"ice-benchmarks/formula27.boogie",
    ROOT+"ice-benchmarks/sqrt.boogie",
    ROOT+"ice-benchmarks/square.boogie",
    ROOT+"ice-benchmarks/sum4.boogie",
    ROOT+"ice-benchmarks/fig1.boogie",
    ROOT+"ice-benchmarks/w2.boogie",
    ROOT+"ice-benchmarks/w1.boogie",
    ROOT+"ice-benchmarks/afnp.boogie",
    ROOT+"ice-benchmarks/loops.boogie",
    ROOT+"ice-benchmarks/dtuc.boogie",
]

multiple_procedures_select = {
        ROOT+"ice-benchmarks/cegar1.boogie": "cegar1", # interesting stuff happens in cegar1
}

ignore = {
        ROOT+"ice-benchmarks/add.boogie":1 # Recursive function
}

def desugar(fname):
    output = subprocess.check_output([BOOGIE_PATH, "/nologo", "/noinfer", "/traceverify", fname]);
    lines = list(output.split("\n"))
    start = 0;
    res = {}
    print "Desugaring ", f
    r = re.compile("implementation (?P<name>[^(]*)\(", re.MULTILINE)
    while True:
        try:
            code = "\n".join(lines[
                    lines.index("after desugaring sugared commands like procedure calls",start)+1:
                    lines.index("after conversion into a DAG", start)])
            name = r.findall(code)[0]
            res[name] = code;
            start = lines.index("after conversion into a DAG", start) + 1
        except ValueError:
            break;

    return res

"""
desugared_files = [ ]

for f in raw_files:
    if f in ignore:
        continue;

    os.system("cat " + f + "| grep -v invariant > /tmp/out.bpl");
    a = desugar("/tmp/out.bpl");

    if (len(a) != 1):
        if f in multiple_procedures_select:
            code = a[multiple_procedures_select[f]]
        else:
            print "Error:", f, "doesn't have exactly 1 procedure: ", a.keys()
            os.exit(-1)
    else:
        code = a[a.keys()[0]]

    outF = open(f + ".desugared.bpl", "w");
    outF.write(code);
    outF.close();
    desugared_files.append(f + ".desugared.bpl")

single_loop = []
for f in desugared_files:
    try:
        sys.stdout.write("Checking " + f + "for more than 1 loop...")
        bbs = get_bbs(f);
        ls = loops(bbs)
        if (len(ls) != 1):
            print "Yes :(. Ignore"
        else:
            print "No :)"
            single_loop.append(f)
    except:
        print "Exception in:", f

print "Acceptable levels: "

for f in single_loop:
    print f
"""
