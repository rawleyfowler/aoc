our %ops = Map.new('A', 'Y', 'B', 'Z', 'C', 'X');

sub calculate(@move) {
	my $score = 0;
	
	if (@move[0].ord - @move[1].ord).abs eq 23 {
		$score += 3;
	}

	if %ops{@move[0]} eq @move[1] {
		$score += 6;
	}

	return $score + (@move[1].ord - 87);
}

sub calculate2(@move) {
	if @move[1] eq 'Y' {
		return 3 + (@move[0].ord - 64);
	}

	if @move[1] eq 'X' {
		return (@move[0].ord % 3) + 1;
	}

	return 6 + %ops{@move[0]}.ord - 87;
}

# Part 1 (14531)
say "input.txt".IO.slurp.chomp.split("\n")>>.split(" ").map(&calculate).sum;

# Part 2 (11258)
say "input.txt".IO.slurp.chomp.split("\n")>>.split(" ").map(&calculate2).sum;
