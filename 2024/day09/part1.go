package main

import (
  "fmt"
  "io/ioutil"
  "strconv"
  "strings"
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

  j := len(blocks) - 1

  for i := 0; i < len(blocks); i++ {
    if blocks[i] == "." {
      for j > i && blocks[j] == "." {
        j--
      }

      if j > i {
        blocks[i], blocks[j] = blocks[j], blocks[i]
      }
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
