use strict;
use warnings;
use Plack::Builder;
use Log::Dispatch::FileWriteRotate;
use Data::Section::Simple qw(get_data_section);

use MyLib::CurrentTime qw(current_time_str);

my $page_html = get_data_section("index.html");

my $app = sub {
    my $env = shift;
    return [200,
            ["Content-Type" => "text/html; charset=UTF-8",
             "Content-Length" => length($page_html)],
            [$page_html]];
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

__DATA__

@@ index.html
<!DOCTYPE html>
<html>
  <head>
    <title>My WebSocket Chat on OpenShift Online</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <style type="text/css">
      pre {
         border: 3px solid #333;
         border-radius: 5px;
         padding: 10px;
         margin: 5px 20px;
         height: 300px;
         overflow: scroll;
      }
      #user-comment {
          width: 400px;
      }
    </style>
  </head>
  <body>
    <h1>WebSocket Chat</h1>
    <pre id="chat-box"></pre>
    <ul>
      <li>Name: <input id="user-name" type="text" value="" /></li>
      <li>Comment: <input id="user-comment" type="text" value="" /></li>
    </ul>
    <script src="//ajax.googleapis.com/ajax/libs/jquery/1.10.2/jquery.min.js"></script>
</html>
