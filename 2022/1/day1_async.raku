my Channel $chan = Channel.new;
my @elfs = split "\n\n", open('input.txt', :r).slurp;

for @elfs -> $elf {
	start {
		$chan.send($elf.lines.sum);
	}
}

my Int $count = 0;
my Int @maxes = ();

while not $count eq @elfs.elems {
	@maxes.push($chan.receive);
	if @maxes.elems >= 4 {
		@maxes = @maxes.sort.tail(3);
	}
	$count++;
}

# First problem (68787)
say @maxes.max;

# Second problem (198041)
say @maxes.sum;
