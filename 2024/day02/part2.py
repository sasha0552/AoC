result = 0

with open("input.txt", "r") as file:
  for line in file:
    data = list(map(int, line.rstrip().split(" ")))
    success = False
    for data in [data] + [data[:i] + data[i + 1:] for i in range(len(data))]:
      inc = all(a < b for a, b in zip(data, data[1:]))
      dec = all(a > b for a, b in zip(data, data[1:]))
      stp = all(abs(a - b) in {1, 2, 3} for a, b in zip(data, data[1:]))
      if (inc or dec) and stp:
        success = True
    if success:
      result = result + 1

print(result)
