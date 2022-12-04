use v6;

my @lines = "input.txt".IO.lines;

sub find_common(@input) {
	my $len = @input.elems;
	my $itr = @input.iterator;
	my @left = $itr.pull-one;
	my @right = ($itr.pull-one for ^($len - 1));

	for @left -> $char {
		if @right.map( *.contains($char) ).sum eq $len - 1 {
			if $char.ord >= 96 { return $char.ord - 96 } else { return $char.ord - 38 };
		}
	}
	
	return 0;
}

# Part 1 (8515)
@lines.map({ ($^a.substr(0..($^a.chars/2) - 1), $^a.substr($^a.chars/2..*)) }).map({ ($^a[0].split("", :skip-empty), $^a[1].split("", :skip-empty)) }).map(&find_common).sum.say;

# Part 2 (2434)
@lines.batch(3).map({ $^a.map(*.split("", :skip-empty)) }).map(&find_common).sum.say;
