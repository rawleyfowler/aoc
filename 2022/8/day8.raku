use v6;

class Tree {
	has Bool $.visible_left is rw = False;
	has Bool $.visible_right is rw = False;
	has Bool $.visible_up is rw = False;
	has Bool $.visible_down is rw = False;
	has Int $.distance_left is rw = 0;
	has Int $.distance_right is rw = 0;
	has Int $.distance_up is rw = 0;
	has Int $.distance_down is rw = 0;
	has Int $.height;
}

my @grid = 'input.txt'.IO.slurp.lines.map({ .split('', :skip-empty).map({ Tree.new(height => .Int) }).Array }).Array;

sub is_interior_visible(Int $i, Int $j, @grid, Tree $value) {
	
	# Up
	loop (my $k = $i - 1; $k >= 0; $k--) {
		if @grid[$k][$j].height < $value.height || $k == $i {
			$value.distance_up++;
			if @grid[$k][$j].visible_up {
				if $k > 0 {
					$value.distance_up += @grid[$k][$j].distance_up;
				}
				$value.visible_up = True;
				last;
			}
		} else {
			$value.distance_up++;
			last;
		}
	}

	# Down
	loop (my $v = $i + 1; $v < @grid.elems; $v++) {
		if @grid[$v][$j].height < $value.height {
			$value.distance_down++;
			if @grid[$v][$j].visible_down {
				if $v < @grid.elems - 1 {
					$value.distance_down += @grid[$v][$j].distance_down;
				}
				$value.visible_down = True;
				last;
			}
		} else {
			$value.distance_down++;
			last;
		}
	}


	# Left
	loop (my $g = $j - 1; $g >= 0; $g--) {
		if @grid[$i][$g].height < $value.height {
			$value.distance_left++;
			if @grid[$i][$g].visible_left {
				if $g > 0 {
					$value.distance_left += @grid[$i][$g].distance_left;
				}
				$value.visible_left = True;
				last;
			}
		} else {
			$value.distance_left++;
			last;
		}
	}

	# Right
	loop (my $l = $j + 1; $l < @grid[$i].elems; $l++) {
		if @grid[$i][$l].height < $value.height {
			$value.distance_right++;
			if @grid[$i][$l].visible_right {
				if $l < @grid[$i].elems - 1 {
					$value.distance_right += @grid[$i][$l].distance_right;
				}
				$value.visible_right = True;
				last;
			}
		} else {
			$value.distance_right++;
			last;
		}
	}
}

sub handle_edges(@grid) {
	my $i = 0;
	for @grid -> @row {
		if $i != 0 && $i != @grid.elems - 1 {
			@row[0].visible_left = True;
			@row[@row.elems - 1].visible_right = True;
		} else {
			if $i == 0 {
				for @row -> $tree { $tree.visible_up = True; }
			} else {
				for @row -> $tree { $tree.visible_down = True; }
			}
		}
		$i++;
	}
}

handle_edges(@grid);

loop (my $i = 1; $i < @grid.elems - 1; $i++) {
	loop (my $j = 1; $j < @grid[$j].elems - 1; $j++) {
		is_interior_visible($i, $j, @grid, @grid[$i][$j]);
	}
}

# Part 1 (1533)
@grid>>.map({ .visible_left || .visible_right || .visible_up || .visible_down }).flat.sum.say;

# Part 2 (345744)
@grid>>.map({ .distance_left * .distance_right * .distance_up * .distance_down }).flat.max.say;
