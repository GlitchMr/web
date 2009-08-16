use v6;

use HTTP::Daemon;

class Web::Handler::HTTPDaemon {
    method run(Callable &app, :$port = 8888) {
        my HTTP::Daemon $d .= new(LocalPort => $port);
        while my $c = $d.accept and my HTTP::Request $r = $c.get_request {
            my $qs = $r.url.path ~~ / '?' (.*) $/ ?? $0 !! '';
            my %env = { "QUERY_STRING" => $qs };
            $c.send_response(&app(%env)[2].Str)
        }
    }
}
