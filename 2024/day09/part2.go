package main

import (
  "fmt"
  "io/ioutil"
  "strconv"
  "strings"
  "sort"
)

func main() {
  data, err := ioutil.ReadFile("input.txt")

  if err != nil {
    panic(err)
  }

  inp := strings.TrimSpace(string(data))

  if len(inp) % 2 == 1 {
    inp += "0"
  }

  ///// ///// ///// ///// /////

  var blocks []string

  for idx := 0; idx < len(inp); idx += 2 {
    fullBlocks, _ := strconv.Atoi(string(inp[idx]))
    emptyBlocks, _ := strconv.Atoi(string(inp[idx + 1]))

    for i := 0; i < fullBlocks; i++ {
      blocks = append(blocks, strconv.Itoa(idx / 2))
    }

    for i := 0; i < emptyBlocks; i++ {
      blocks = append(blocks, ".")
    }
  }

  ///// ///// ///// ///// /////

  fileIDs := make(map[string]struct{})

  for _, idx := range blocks {
    if idx != "." {
      fileIDs[idx] = struct{}{}
    }
  }

  /////

  var sortedFileIDs []int

  for idx := range fileIDs {
    num, _ := strconv.Atoi(idx)
    sortedFileIDs = append(sortedFileIDs, num)
  }

  sort.Slice(sortedFileIDs, func(i, j int) bool {
    return sortedFileIDs[i] > sortedFileIDs[j]
  })

  for _, idx := range sortedFileIDs {
    fileID := strconv.Itoa(idx)
    positions := []int{}

    for i, x := range blocks {
      if x == fileID {
        positions = append(positions, i)
      }
    }

    size := len(positions)
    currentPosition := positions[0]

    maxPosition := currentPosition - 1
    found := true

    for i := 0; i <= maxPosition-size+1; i++ {
      valid := true

      for j := i; j < i+size; j++ {
        if blocks[j] != "." {
          valid = false
          break
        }
      }

      if valid {
        for _, pos := range positions {
          blocks[pos] = "."
        }

        for j := i; j < i+size; j++ {
          blocks[j] = fileID
        }

        found = true
        break
      }
    }

    if !found {
      continue
    }
  }

  ///// ///// ///// ///// /////

  result := 0

  for i, block := range blocks {
    if block != "." {
      idx, _ := strconv.Atoi(block)
      result += i * idx
    }
  }

  fmt.Println(result)
}
