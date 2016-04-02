def unique(iterable, msg=""):
  l = list(iterable)
  assert len(l) == 1, msg
  return l[0]
