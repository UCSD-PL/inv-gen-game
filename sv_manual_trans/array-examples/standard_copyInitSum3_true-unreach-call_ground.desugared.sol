{
 "anon11_LoopHead": "(forall k: int :: (0 <=k && k < i) ==> a[k] == 42)",
 "anon12_LoopHead": ["(forall k: int :: (0 <=k && k < i) ==> a[k] == b[k])",
                     "(forall k: int :: (0 <=k && k < 100000) ==> a[k] == 42)", "i>=0", "i<=100000"],
 "anon13_LoopHead": ["(forall k: int :: (i <=k && k < 100000) ==> a[k] == b[k])",
                     "(forall k: int :: (0 <=k && k < i) ==> a[k]+k == b[k])", "i>=0", "i<=100000"],
 "anon14_LoopHead": ["(forall k: int :: (i <=k && k < 100000) ==> a[k]+k == b[k])",
                     "(forall k: int :: (0 <=k && k < i) ==> k == b[k])", "i>=0", "i<=100000"],
 "anon15_LoopHead": ["(forall k: int :: (0 <=k && k < 100000) ==> k == b[k])", "x>=0"]
}
