use v6;

class File {
	has Str $.name;
	has Int $.size;
}

class GraphNode {
	has Str $.name;
	has GraphNode @.children;
	has GraphNode $.parent;
	has File @.files;

	method size() {
		my %sizes;
		
		sub do_calculate(GraphNode $node) {
			%sizes{$node.fqdn} = 0;
			for $node.files -> $file { %sizes{$node.fqdn} += $file.size }
			for $node.children -> $child { %sizes{$node.fqdn} += do_calculate($child) }
			return %sizes{$node.fqdn};
		}
		
		return do_calculate(self);
	}

	method file_count() {
		return @.files.elems + @.children.map({ .file_count }).flat.sum;
	}

	method fqdn() {
		if $.name eq "/" { return "/"; }
		return $.parent.fqdn ~  $.name ~ "/";
	}
}

my $input = 'input.txt'.IO.slurp.chomp;

my GraphNode $curr_node = GraphNode.new(name => "/", children => Array.new, parent => Nil, files => Array.new);
my GraphNode $root_node = $curr_node;

for $input.split("\n").skip(2) -> $line {
	if $line ~~ /^\$.+$/ {
		my $cmd = $line.split(' ')[1];
		if $cmd eq 'cd' {
			my $tar = $line.split(' ')[2];
			if $tar eq '..' {
				$curr_node = $curr_node.parent;
			} elsif $tar eq '/' {
				$curr_node = $root_node;
			} else {
				$curr_node = GraphNode.new(name => $tar, children => Array.new, parent => $curr_node, files => Array.new);
				$curr_node.parent.children.push($curr_node);
			}
		} else { next; }
	} elsif $line ~~ /^\d.+$/ {
		my $parts = $line.split(' ');
		my File $f = File.new(name => $parts[1], size => $parts[0].Int);
		$curr_node.files.push($f);
	}
}

sub find_deletion_candidates(GraphNode $root) {
	my %sizes;
	
	sub do_calculate(GraphNode $node) {
		%sizes{$node.fqdn} = 0;
		for $node.files -> $file { %sizes{$node.fqdn} += $file.size }
		for $node.children -> $child { %sizes{$node.fqdn} += do_calculate($child) }
		return %sizes{$node.fqdn};
	}
	
	do_calculate($root);

	return %sizes.values;
}

# Part 1 (1391690)
say find_deletion_candidates($root_node).grep({ $^a <= 100000 }).sum;

# Part 2 (5469168)
sub bfs_min_with_target_and_start(GraphNode $node, Int $start, Int $target) {
	my @queue = Array.new($node);
	my $curr_min = 999999999;

	while @queue.elems {
		my $t = @queue.shift;
		for $t.children -> $child { @queue.push($child) }
		my $size = $t.size;
		if $size < $curr_min && ($size + $start) >= $target {
			$curr_min = $size;
		}
	}

	return $curr_min;
}

bfs_min_with_target_and_start($root_node, 70000000 - $root_node.size, 30000000).say;
