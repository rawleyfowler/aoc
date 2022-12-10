use v6;

sub run_instructions(@instructions, @crates, $batches = 1) {
	for @instructions -> @op {
		my @resulting_crates;
		my $val = @op[0];
		my $from = @op[1] - 1;
		my $to = @op[2] - 1;
		if $batches != 1 {
			@crates[$to].append((@crates[$from].pop for ^$val).reverse);
		} else {
			@crates[$to].push(@crates[$from].pop) for ^@op[0];
		}
	}
	
	return @crates;
}

my @raw = 'bigboy.txt'.IO.slurp.chomp.split("\n\n");
my @instructions = @raw[1].split("\n").map({ $^a.comb(/\d+/).map({ .Int }) });
my @sanitized_crates = @raw[0].split("\n");
my @crates = @sanitized_crates.tail.comb(/\d+/).map({ @sanitized_crates.tail.index($^a) }).map({ @sanitized_crates.map( *.split("", :skip-empty)[$^a] ).grep(/<[A..Za..z]>/).reverse.List }).List;

# Part 1 (SVFDLGLWV)
say [~] run_instructions(@instructions, @crates.clone.map({ .Array.clone })).map({ .tail });

# Part 2 (DCVTCVPCL)
say [~] run_instructions(@instructions, @crates.clone.map({ .Array.clone }), 3).map({ .tail });
