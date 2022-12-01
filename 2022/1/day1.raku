my Int @totals = (0);
my Int $tick = 0;

for 'input.txt'.IO.lines -> $line {
	if $line eq '' {
		$tick++;
		@totals.push(0);
		next;
	} else {
		@totals[$tick] += +$line;
	}
}

# First problem
say reduce &max, @totals;

# Second problem
say @totals.sort.reverse.head(3).sum;
