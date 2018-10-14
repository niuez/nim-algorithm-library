import system, macros, algorithm, tables, sets, lists, queues, intsets, critbits, sequtils, strutils, math, future

var input : seq[string] = @[]
var in_cnt = 0

proc gs() : string =
  if input.len == in_cnt:
    in_cnt = 0
    input = stdin.readline.split
  in_cnt += 1
  return input[in_cnt - 1]

proc gi() : int =
  return gs().parseInt
proc gf() : float =
  return gs().parseFloat


