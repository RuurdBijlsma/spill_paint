from std/random import sample, randomize, rand

type Cell* = enum
  Red, Yellow, Green, Blue, Purple, Brown

const Width = 10
const Height = 10
const origin* = (0, 0)
type Grid* = ref array[Width, array[Height, Cell]]

proc `[]`*(g: Grid, x, y: int): Cell =
  return g[x][y]
proc `[]=`*(g: Grid, x, y: int, val: Cell) = 
  g[x][y] = val

type Game* = ref object 
  grid*: Grid
  ended*: bool
  turn*: Cell


const neighbours = [
  (1, 0),# right
  (-1, 0),# left
  (0, 1),# bottom
  (0, -1),# top
]

proc checkWin*(self: Game): bool =
  var color = self.grid[0, 0]
  for x in 0..<Width:
    for y in 0..<Height:
      if self.grid[x, y] != color:
        return false
  return true

proc doMove*(self: Game, color: Cell) =
  var queue = newSeq[(int, int)]()
  queue.add(origin)
  let originalColor = self.grid[origin[0], origin[1]]
  while queue.len > 0:
      var (x, y) = queue[queue.high]
      self.grid[x, y] = color
      queue.delete(queue.high)

      for (xp, yp) in neighbours:
          var xn = x + xp
          var yn = y + yp
          if xn < 0 or xn >= Width or yn < 0 or yn >= Height or self.grid[xn, yn] != originalColor:
              continue
          queue.add((xn, yn))

proc restart(self: Game) =
  for x in 0..<Width:
    for y in 0..<Height:
      self.grid[x, y] = Cell(rand(Cell.low..Cell.high))

proc initGame*(): Game =
  randomize()
  let game = Game(turn: Cell.Red)
  game.grid = new(Grid)
  game.restart()
  return game

proc print*(grid: Grid) =
  echo "====================================="
  for y in 0..<Height:
    for x in 0..<Width:
      let val = grid[x, y]
      if val == Cell.Red:
        stdout.write("🔴 ")
      if val == Cell.Yellow:
        stdout.write("🟡 ")
      if val == Cell.Green:
        stdout.write("🟢 ")
      if val == Cell.Blue:
        stdout.write("🔵 ")
      if val == Cell.Purple:
        stdout.write("🟣 ")
      if val == Cell.Brown:
        stdout.write("🟠 ")
    stdout.write("\n")
  stdout.write("\n")
  flushFile(stdout)