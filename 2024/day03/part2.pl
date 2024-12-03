$enabled = 1;
$result = 0;

open(FH, "<", "input.txt") or die $!;
while (<FH>) {
  while ($_ =~ /(do\(\))|(don't\(\))|(mul\((\d+),\s{0,}(\d+)\))/g) {
    if ($1 eq "do()") {
      $enabled = 1;
    }
    if ($2 eq "don't()") {
      $enabled = 0;
    }
    if ($enabled) {
      $result += $4 * $5;
    }
  }
}
close(FH);

print("$result\n");
