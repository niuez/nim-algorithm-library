import algorithm

proc HavelHakimi*(deg : seq[int]) : bool =
  ## Havel Hakimi Algrithm. takes O(N)
  ## it answers the following question: Given a finite list of nonnegative integers, is there a simple graph such that its degree sequence is exactly this list.
  var
    d = deg
    N = deg.len
  d.sort(system.cmp)
  d.reverse
  d.add(0)
  for i in countdown(N - 1, 0):
    d[i + 1] -= d[i]
  for i in 0..<N:
    d[i + 1] += d[i]
    echo d[i]
    if i + d[i] >= N:
      return false
    d[i + 1] -= 1
    d[i + d[i] + 1] += 1
  return true
