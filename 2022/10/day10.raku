use v6;

class Instruction {
	has Int $.cycle_count;
	has Str $.name;
	has Str $.arg;
}

sub run_instructions(@instructions, &handler, &cb) {
	my $register = 1;
	my $cycle = 0;

	for @instructions -> Instruction $instruction {
		for ^$instruction.cycle_count {
			$cycle++;
			&cb($cycle, $register);
		}

		if $instruction.arg {
			$register = &handler($instruction, $register);
		}
	}
}

my %instruction_set = Hash.new("noop" => 1, "addx" => 2);
my @instructions = 'input.txt'.IO.slurp.chomp.split("\n").map({ .split(" ") }).map({ Instruction.new(cycle_count => %instruction_set{$_[0]}, name => $_[0], arg => $_[1] || "") });

sub handle_instruction(Instruction $instruction, Int $register) {
	if $instruction.name eq "addx" {
		return $register + $instruction.arg.Int;
	}

	return $register;
}

my @cycle_totals = Array.new;
sub cycle_callback($cycle, $register) {
	my @cycle_tallies = [20, 60, 100, 140, 180, 220];
	if $cycle (elem) @cycle_tallies {
		@cycle_totals.push($cycle * $register);
	}
}

# Part 1 (15360)
run_instructions(@instructions, &handle_instruction, &cycle_callback);
say @cycle_totals.sum;

my @crt = Array.new(0..5).map({ Array.new(0..39).map({ '.' }).split(" ", :skip-empty).Array });
sub crt_callback($cycle, $register) {
	my @sprite = Array.new(0..39).map({ '.' }).split(" ", :skip-empty).Array;
	my $row = (($cycle - 1) / 40).floor;
	my $column = ($cycle - 1) mod 40;

	say $column;
	if $register > 0 {
		@sprite[$register] = '#';

		if ($register - 1) >= 0 {
			@sprite[$register - 1] = '#';
		}

		if $register + 1 > 0 {
			@sprite[$register + 1] = '#';
		}
	}
	
	@crt[$row][$column] = @sprite[$column];
}

# Part 2 (PHLHJGZA)
run_instructions(@instructions, &handle_instruction, &crt_callback);
say @crt.map({ .join }).join("\n");
