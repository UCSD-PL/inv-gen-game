from ctypes import *
from z3 import *
import os

c_int_p = POINTER(c_int)

MYDIR = os.path.dirname(os.path.realpath(__file__))

class GlobalSO(CDLL):
   def __init__(self, name):
        CDLL.__init__(self, name, RTLD_GLOBAL)

gso = LibraryLoader(GlobalSO)

l = gso.LoadLibrary(MYDIR + '/binding.so')

def entry(fname, *args):
#    print "Calling ", fname, " with args ", args
    return 0

def entryFactory(ind):
    def entryF(*args):
        return entry(funcs[ind], *args)
    return entryF

def start_tp(loopId):
    print "Starting tracepoint ", loopId
    return 0

def end_tp(loopId):
    print "Ending tracepoint ", loopId
    return 0

def type_conv(typeId):
    return {
        0: int 
    }[typeId]

def val_conv(ptr, typ):
    if (typ == int):
        return cast(ptr, c_int_p).contents.value
    else:
        raise Exception("Can't convert type: " + str(typ))

def add_val(name, typ, addr):
    s = cast(name, c_char_p)
    typ = type_conv(typ)
    print "Adding value of ", s.value, " of type ", typ, " located at ", addr,\
     " with value ", val_conv(addr, typ)
    return 0

funcs = {
   0 :  ("unknown", c_int, ()), # F_UNKNOWN
   1 :  ("unknown1", c_int, ()), # F_UNKNOWN1
   2 :  ("unknown2", c_int, ()), # F_UNKNOWN2
   3 :  ("unknown3", c_int, ()), # F_UNKNOWN3
   4 :  ("unknown4", c_int, ()), # F_UNKNOWN4
   5 :  ("unknown5", c_int, (c_bool,)), # F_STATIC_ASSERT_
   6 :  ("assume", c_int, (c_bool,)), # F_ASSUME
}

ftypes = []
cbs = []

for ind in funcs:
    name, ret, args = funcs[ind]
    ftype = CFUNCTYPE(ret, *args) 
    ftypes.append(ftype) # prevent GC

    cb = ftype(entryFactory(ind))
    cbs.append(cb)

    l.register_cb(ind, cb)

start_tp_ftype = CFUNCTYPE(c_int, c_int)
start_tp_cb = start_tp_ftype(start_tp)
l.register_cb(7, start_tp_cb);

add_val_ftype = CFUNCTYPE(c_int, c_void_p, c_int, c_void_p)
add_val_cb = add_val_ftype(add_val)
l.register_cb(8, add_val_cb);

end_tp_ftype = CFUNCTYPE(c_int, c_int)
end_tp_cb = end_tp_ftype(end_tp)
l.register_cb(9, end_tp_cb);

for i in xrange(1, 2):
    name = "/home/dimo/work/inv_game/inv-gen-game/dilig-benchmarks/%s.so" % str(i).zfill(2)
    print name
    l1 = cdll.LoadLibrary(name)
    l1.main()
