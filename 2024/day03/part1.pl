$result = 0;

open(FH, "<", "input.txt") or die $!;
while (<FH>) {
  while ($_ =~ /mul\((\d+),\s{0,}(\d+)\)/g) {
    $result += $1 * $2;
  }
}
close(FH);

print("$result\n");
