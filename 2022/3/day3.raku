my $splits = "input.txt".IO.lines.map({ ($^a.substr(0..($^a.chars/2) - 1), $^a.substr($^a.chars/2..*)) });

# Part 1
$splits>>.map({ $^a ~~ /$^b.split("").join("|")/ }).say;

# Part 2
