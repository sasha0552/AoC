import algorithm, os, sequtils, strutils, sugar

let parts = readFile("input.txt").strip().split("\n\n")
let ordering = parts[0].strip().splitLines().map(line => (line.split("|")[0], line.split("|")[1]))
let pages = parts[1].strip().splitLines().map(line => line.split(","))

##### ##### ##### ##### ######

var results = 0

for pageList in pages:
  var valid = true

  for (k, v) in ordering:
    if k in pageList and v in pageList:
      if pageList.map(x => x == k).find(true) > pageList.map(x => x == v).find(true):
        valid = false
        break

  if not valid:
    var sortedPageList = pageList

    sortedPageList.sort do (x, y: string) -> int:
      if x == y:
        return 0    

      for (k, v) in ordering:
        if x == k and y == v:
          return 1

        if x == v and y == k:
          return -1

      return 0

    results += sortedPageList[sortedPageList.len div 2].parseInt()

echo results
