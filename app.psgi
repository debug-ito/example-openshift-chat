use strict;
use warnings;
use Plack::Builder;
use Log::Dispatch::FileRotate;

my $app = sub {
    my $env = shift;
    my $body = "It works!";
    return [200,
            ["Content-Type" => "text/plain",
             "Content-Length" => length($body)],
            [$body]];
};

my $logger = Log::Dispatch::FileRotate->new(
    name => "access",
    min_level => "info",
    filename => "$ENV{OPENSHIFT_PLACK_LOG_DIR}/access.log",
    mode => "append",
    size => 50,
    max  => 5
);

builder {
    enable "AccessLog", logger => sub {
        $logger->log(level => "info", message => $_[0]);
    };
    $app;
};
