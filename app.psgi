use strict;
use warnings;

sub {
    my $env = shift;
    my $body = "It works!";
    return [200,
            ["Content-Type" => "text/plain",
             "Content-Length" => length($body)],
            [$body]];
};
