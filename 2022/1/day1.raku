my Int @totals = (0, 0, 0, 0);

for 'input.txt'.IO.lines -> $line {
	if $line eq '' {
		@totals = @totals.sort;
		if @totals.elems >= 4 {
			@totals[0] = 0;
		}
	} else {
		@totals[0] += $line;
	}
}

# First problem (68787)
say @totals.max;

# Second problem (198041)
say @totals.tail(3).sum;
