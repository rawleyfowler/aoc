use v6;

sub find_unique_seq(@text, $size) {
	my @buff;
	my $pairs = @text.split('', :skip-empty).antipairs.iterator;
	loop {
		my $pair := $pairs.pull-one;
		@buff.shift while @buff.map({ .key }).contains($pair.key);
		@buff.push($pair);
		last if @buff.elems eq $size;
	}
	return @buff;
}

my @text = 'input.txt'.IO.slurp.chomp;

# Part 1 (1779)
my $p1 = find_unique_seq(@text, 4).tail.value;
say $p1.succ;

# Part 2 (
find_unique_seq(@text, 14).tail.value.succ.say;
