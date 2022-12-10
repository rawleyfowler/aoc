use v6;

sub adjust_tail(@head, @old_head, @tail) {
	my @zip = (zip @head, @tail)>>.map({ ($^a - $^b).abs > 1 }).flat;
	my @old_tail = @tail.clone;

	if @zip.any {
		@tail[0] = @old_head[0];
		@tail[1] = @old_head[1];
	}

	return @old_tail;
}

sub move_rope(@head, @tail, Str $direction) {
	my @old_head = @head.clone;
	
	if $direction eq "R" {
		@head[0]++;
	} elsif $direction eq "L" {
		@head[0]--;
	} elsif $direction eq "U" {
		@head[1]++;
	} elsif $direction eq "D" {
		@head[1]--;
	}

	my @old_tail = adjust_tail(@head, @old_head, @tail.head);

	if @tail.elems > 1 {
		my $i = 0;
		for @tail[1..*] -> @t {
			say @old_tail, " ", $i;
			@old_tail = adjust_tail(@tail[$i], @old_tail, @t);
			$i++;
		}
	}
}

sub calculate_tail_positions(@head, @tail, @movements) {
	my @tail_positions = Array.new;
	
	for @movements -> @move {
		my $times = @move.tail;
		for ^$times {
			move_rope(@head, @tail, @move.head);
			@tail_positions.push(@tail.tail.head ~ ", " ~ @tail.tail.tail);
		}
	}
	
	return @tail_positions;
}


my @head = [0, 0];
my @tail = Array.new.push([0,0]);
my @movements = 'input_test_large.txt'.IO.slurp.chomp.split("\n")>>.split(" ");

# Part 1 (6057)
say calculate_tail_positions(@head, @tail, @movements).unique.elems;

@head = [0, 0];
@tail = Array.new(0..8).map({ [0,0] });

# Part 2 
say calculate_tail_positions(@head, @tail, @movements).raku;
