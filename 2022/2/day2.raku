our %ops = Map.new('A', 1, 'B', 2, 'C', 3,
				   'X', 1, 'Y', 2, 'Z', 3);

sub calculate(Int $i, Int $j) {
	if $i eq $j { return 3 + $j; }
	if ($j % 3) + 1 eq $i { return $j; }
	return 6 + $j;
}

my @hands = "input.txt".IO.slurp.chomp.split("\n")>>.split(" ").map({ (%ops{@^a[0]}, %ops{@^a[1]}) });

# Part 1 (14531)
@hands>>.reduce(&calculate).sum.say;

# Part 2 (11258)
say @hands>>.reduce({ ($^a + $^b % 3) % 3 + 1 + 3 * ($^b - 1) }).sum;
