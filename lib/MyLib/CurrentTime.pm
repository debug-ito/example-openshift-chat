package MyLib::CurrentTime;
use strict;
use warnings;
use Exporter qw(import);
use Time::Piece;

our @EXPORT_OK = qw(current_time_str);

sub current_time_str {
    my $time = gmtime;
    return $time->cdate . " UTC";
}

1;
