use strict;
use warnings;
use Plack::Builder;
use Log::Dispatch::FileWriteRotate;

my $app = sub {
    my $env = shift;
    my $body = "It works!";
    return [200,
            ["Content-Type" => "text/plain",
             "Content-Length" => length($body)],
            [$body]];
};

my $logger = Log::Dispatch::FileWriteRotate->new(
    min_level => "info",
    dir => $ENV{OPENSHIFT_PLACK_LOG_DIR},
    prefix => "access.log",
    size => 50*1024*1024,
    histories => 5
);

builder {
    enable "AccessLog", logger => sub {
        $logger->log(level => "info", message => $_[0]);
    };
    $app;
};
