{
 "anon11_LoopHead": ["(!(found) ==> (forall k: int :: (0<= k && k < i) ==> vectorx[k] != element))",
                     "found ==> ((forall k: int :: (0<= k && k < i-1) ==> vectorx[k] != element) && vectorx[i-1] == element && pos == i-1)"],
 "anon14_LoopHead": "found ==> ((forall k: int :: (0<= k && k < pos) ==> vectorx[k] != element) && i >= pos)",
 "anon16_LoopHead": ["(forall k: int :: (0<= k && k < pos) ==> vectorx[k] != element)", "x>=0"]
}
