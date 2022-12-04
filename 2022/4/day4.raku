use v6;

my @lines = 'input.txt'.IO.lines;
my @ranges = @lines.map(*.split(",", :skip-empty))>>.map(*.split("-", :skip-empty)).map({ (@^a[0][0].Int..@^a[0][1].Int, @^a[1][0].Int..@^a[1][1].Int) });

sub range_contains($left, $right) {
	return ($left ~~ $right) || ($right ~~ $left);
}

sub overlap($left, $right, $recur = True) {
	my $t = $left.min < $right.max && $left.max > $right.min;
	if $recur {
		return $t || overlap($left, $right, False);
	}
	return $t;
}

# Part 1 (462)
@ranges>>.map(&range_contains).map(*[0]).sum.say;

# Part 2 (835)
@ranges>>.map(&overlap).map(*[0]).sum.say;
