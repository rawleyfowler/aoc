use v6;

sub bfs_find_steps_to_end(@map, @start) {
  my @queue = Array.new;
  my @visited;
  my $steps = 0;
  @queue.push(@start); # Push starting position
  while @queue.elems {
    next if @queue[0].raku (elem) @visited;
    my @curr = @queue.shift.flat;
    my ($i, $j) = @curr;

    if @map[$i][$j] eq 'E' {
      say $steps;
      last;
    }

    my $v = -1;

    if (@map[$i][$j] == 'S') { $v = 'a'.; } else { $v = @map[$i][$j].ord; }

    if $i - 1 >= 0 && @map[$i - 1][$j] && @map[$i - 1][$j].ord - $v == 1 {
      @queue.push([$i-1, $j]);
    }

    if $i + 1 < @map.elems && @map[$i + 1][$j].ord - $v == 1 {
      @queue.push([$i+1, $j]);
    }

    if $j + 1 < @map[$i].elems && @map[$i][$j + 1].ord - $v == 1 {
      @queue.push([$i, $j+1]);
    }

    if $j - 1 >= 0 && @map[$i][$j - 1].ord - $v == 1 {
      @queue.push([$i, $j-1]);
    }

    @visited.push(@curr.raku);
    $steps++;
  }
}

my @map = 'input.txt'.IO.slurp.chomp.split(/\n/).map({ .split("", :skip-empty).Array }).Array;

say bfs_find_steps_to_end(@map, [0, 20]);
