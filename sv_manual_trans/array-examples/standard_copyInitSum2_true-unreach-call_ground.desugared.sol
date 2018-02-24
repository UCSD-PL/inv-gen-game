{
 "anon9_LoopHead": "(forall k : int :: (0 <= k && k < i) ==> a[k] == 42) && i <= 100000",
 "anon10_LoopHead": ["(forall k : int :: (0 <= k && k < i) ==> a[k] == b[k])", "i <= 100000",
                     "(forall k : int :: (0 <= k && k < 100000) ==> a[k] == 42)"],
 "anon11_LoopHead": ["(forall k : int :: (i <= k && k < 100000) ==> b[k] == a[k])", "i <= 100000",
                     "(forall k : int :: (0 <= k && k < i) ==> b[k] == a[k]+k) && i <= 100000",
                     "(forall k : int :: (0 <= k && k < 100000) ==> a[k] == 42)"],
 "anon12_LoopHead": "(forall k : int :: (0 <= k && k < 100000) ==> b[k] == 42+k) && x>=0"
}
