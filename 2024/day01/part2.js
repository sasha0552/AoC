const input = require("fs").readFileSync("input.txt", "utf-8");
const pairs = input.trim().split("\n").map(_ => [ Number(_.split("   ")[0]), Number(_.split("   ")[1]) ]);
const keys = pairs.map(_ => _[0]);
const values = pairs.map(_ => _[1]);

///// ///// ///// ///// /////

let result = 0;

for (let i = 0; i < keys.length; i++) {
  const key = keys[i];
  const matchesFound = values.reduce((acc, val) => val === key ? acc + 1 : acc, 0);
  result += key * matchesFound;
}

console.log(result);
