unit module Util;

sub read_file (Str $url) returns Seq is export {
	return $url.IO.lines;
}
