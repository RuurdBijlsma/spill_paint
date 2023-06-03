import std/strformat
import unittest
import spill_paint
import std/stats

proc bruteForce(print: bool = false): int =
  let game = initGame()
  var moveCount = 0
  while true:
    for color in Cell:
      if color == game.grid[origin[0], origin[1]]:
        continue
      if print:
        echo &"Doing move: {color}"
        game.grid.print()
      game.doMove(color)
      moveCount += 1
      if game.checkWin():
        return moveCount

test "brute force":
  var moveCounts = newSeq[int]()
  const runs = 1000000

  for i in 1..runs:
    let moveCount = bruteForce()
    moveCounts.add(moveCount)
    if i mod 1000 == 0:
      echo &"run {i} / {runs}, moves used: {moveCount}"

  echo &"avg moves: {mean(moveCounts)}"
  # echo &"median moves: {median(moveCounts)}"
  echo &"worst moves: {max(moveCounts)}"
  echo &"best moves: {min(moveCounts)}"
  
