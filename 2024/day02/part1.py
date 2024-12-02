result = 0

with open("input.txt", "r") as file:
  for line in file:
    data = list(map(int, line.rstrip().split(" ")))
    inc = all(a < b for a, b in zip(data, data[1:]))
    dec = all(a > b for a, b in zip(data, data[1:]))
    stp = all(abs(a - b) in {1, 2, 3} for a, b in zip(data, data[1:]))
    if (inc or dec) and stp:
      result = result + 1

print(result)
