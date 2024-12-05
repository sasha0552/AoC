import os, sequtils, strutils, sugar

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

  if valid:
    results += pageList[pageList.len div 2].parseInt()

echo results
