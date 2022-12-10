use v6;

sub adjust_tail_naive(@head, @old_head, @tail) {
	my @zip = (zip @head, @tail)>>.map({ ($^a - $^b).abs > 1 }).flat;

	if @zip.any {
		@tail[0] = @old_head[0];
		@tail[1] = @old_head[1];
	}
}

sub adjust_tail_long(@head, @tail_knots, @tail) {
	my @zip = (zip @head, @tail)>>.map({ ($^a - $^b).abs }).flat;

	if @zip[0] >= 2 || @zip.sum >= 3 {
		@tail[0] += @head[0] > @tail[0] ?? 1 !! -1;
	}
	
	if @zip[1] >= 2 || @zip.sum >= 3 {
		@tail[1] += @head[1] > @tail[1] ?? 1 !! -1;
	}
	
	return unless @tail_knots.elems;
	adjust_tail_long(@tail, @tail_knots[1..*].Array, @tail_knots[0]);
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

	if @tail.elems > 1 {
		adjust_tail_long(@head, @tail, @tail.head);
	} else {
		adjust_tail_naive(@head, @old_head, @tail.head);
	}
}

sub calculate_tail_positions(@head, @tail, @movements) {
	my @tail_positions = Array.new;
	
	for @movements -> @move {
		my $times = @move.tail;
		for ^$times {
			move_rope(@head, @tail, @move.head);
			@tail_positions.push( "(" ~ @tail.tail.head ~ ", " ~ @tail.tail.tail ~ ")" );
		}
	}
	
	return @tail_positions;
}


my @head = [0, 0];
my @tail = Array.new.push([0,0]);
my @movements = 'input.txt'.IO.slurp.chomp.split("\n")>>.split(" ");

# Part 1 (6057)
say calculate_tail_positions(@head, @tail, @movements).unique.elems;

@head = [0, 0];
@tail = Array.new(0..8).map({ [0,0] });

# Part 2 (2514)
say calculate_tail_positions(@head, @tail, @movements).unique.elems;
