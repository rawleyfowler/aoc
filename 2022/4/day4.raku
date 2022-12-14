use v6;

my @lines = 'input.txt'.IO.lines;
my @ranges = @lines.map(*.split(",", :skip-empty))>>.map(*.split("-", :skip-empty)).map({ (@^a[0][0].Int..@^a[0][1].Int, @^a[1][0].Int..@^a[1][1].Int) });

sub range_contains($left, $right) {
	return ($left ~~ $right) || ($right ~~ $left);
}

sub overlap($left, $right) {
	for $left.List -> $val {
		if $val ~~ $right {
			return True;
		}
	}

	return False;
}

# Part 1 (462)
@ranges>>.map(&range_contains).flat.sum.say;

# Part 2 (835)
@ranges>>.map(&overlap).flat.sum.say;
