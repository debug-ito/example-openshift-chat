use strict;
use warnings;
use Plack::Builder;
use Log::Dispatch::FileWriteRotate;
use Data::Section::Simple qw(get_data_section);
use Text::Xslate;
use Plack::App::WebSocket;
use MyLib::CurrentTime qw(current_time_str);  ## located under lib/ directory

my %websockets = ();

sub report_number_of_peole {
    my $socket_num = keys %websockets;
    foreach my $conn (values %websockets) {
        $conn->send("---- There are $socket_num people in this chat now.")
    }
}

my $websocket_endpoint = Plack::App::WebSocket->new(
    on_establish => sub {
        my ($conn) = @_;
        $websockets{"$conn"} = $conn;
        $conn->on(message => sub {
            my ($conn, $message) = @_;
            my $cur_time = current_time_str();
            $message = "[$cur_time] $message";
            foreach my $conn (values %websockets) {
                $conn->send($message);
            }
        });
        $conn->on(finish => sub {
            my ($conn) = @_;
            delete $websockets{"$conn"};
            report_number_of_peole();
        });
        report_number_of_peole();
    }
);

my $template = Text::Xslate->new(
    path => [{index => get_data_section("index.html")}],
    cache_dir => "$ENV{OPENSHIFT_TMP_DIR}/xslate",
);
my $page_html = $template->render("index", { app_fqdn => $ENV{OPENSHIFT_APP_DNS} });


my $app = sub {
    my $env = shift;
    if($env->{PATH_INFO} eq "/websocket") {
        return $websocket_endpoint->call($env);
    }else {
        return [200,
                ["Content-Type" => "text/html; charset=UTF-8",
                 "Content-Length" => length($page_html)],
                [$page_html]];
    }
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
      <li>Comment: <input id="user-comment" type="text" value="" />
                   <input id="user-send" type="button" value="Send" disabled="true" /></li>
    </ul>
    <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.10.2/jquery.min.js"></script>
    <script>
var websocket_url = "ws://<: $app_fqdn :>:8000/websocket";
$(function() {
    var ws = new WebSocket(websocket_url);

    var doSend = function() {
        var text = $("#user-name").val() + ": " + $("#user-comment").val();
        $("#user-comment").val("");
        ws.send(text);
    };
    var showInBox = function(text) {
        $("#chat-box").append($("<span></span>").text(text + "\n"));
    };
    var setHandlers = function() {
        $("#user-send").removeAttr("disabled").on("click", doSend);
        $("#user-comment").on("keydown", function(event) {
            if(event.which === 13) {
                doSend();
                return false;
            }
            return true;
        });
    };
    var removeHandlers = function() {
        $("#user-send").attr("disabled", "true").off("click");
        $("#user-comment").off("keydown");
    };
    
    ws.onopen = function() {
        showInBox("---- WebSocket opened.");
        setHandlers();
    };
    ws.onmessage = function(event) {
        showInBox(event.data);
    };
    ws.onclose = function() {
        removeHandlers();
        showInBox("---- WebSocket closed unexpectedly.");
    }
});
    </script>
</html>
