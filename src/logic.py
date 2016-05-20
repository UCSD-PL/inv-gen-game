from z3 import *

def implies(inv1, inv2):
    s = Solver();
    s.add(inv1)
    s.add(Not(inv2))
    return unsat == s.check();

def equivalent(inv1, inv2):
    s = Solver();
    s.push();
    s.add(inv1)
    s.add(Not(inv2))
    impl = s.check();
    s.pop();

    if (impl != unsat):
      return False;

    s.push();
    s.add(Not(inv1))
    s.add(inv2)
    impl = s.check();
    s.pop();

    if (impl != unsat):
      return False;

    return True

def tautology(inv):
    s = Solver();
    s.add(Not(inv))
    return (unsat == s.check())

