const input = require("fs").readFileSync("input.txt", "utf-8");
const pairs = input.trim().split("\n").map(_ => [ Number(_.split("   ")[0]), Number(_.split("   ")[1]) ]);
const keys = pairs.map(_ => _[0]);
const values = pairs.map(_ => _[1]);

///// ///// ///// ///// /////

let result = 0;

for (let i = 0, j = keys.length; i < j; i++) {
  const findAndPopSmallestVal = (array) => {
    const val = Math.min(... array);
    const idx = array.indexOf(val);

    if (idx !== -1) {
      array.splice(idx, 1);
      return val;
    }

    throw new Error("unreachable");
  }

  const smallestKey = findAndPopSmallestVal(keys);
  const smallestValue = findAndPopSmallestVal(values);

  let distance = 0;
  if (smallestKey > smallestValue) {
    distance = smallestKey - smallestValue;
  } else if (smallestKey < smallestValue) {
    distance = smallestValue - smallestKey;
  }

  result += distance;
}

console.log(result);
