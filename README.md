# Example Application of OpenShift Plack/PSGI cartridge

This is an example application using
[OpenShift Plack/PSGI cartridge](https://github.com/debug-ito/openshift-cartridge-plack).

## About This App

- A simple chat application with only one chat room.
- Use [Twiggy](https://metacpan.org/pod/Twiggy) for the PSGI server.
- No Web application framework.
- Chat messages are delivered through WebSockets, using [Plack::App::WebSocket](https://metacpan.org/pod/Plack::App::WebSocket).

## How to Deploy

- Create an app using the Plack cartridge.
  See https://github.com/debug-ito/openshift-cartridge-plack
- Replace the content of the app directory with this example.
- `git commit` the changes.
- `git push`


## Author

Toshio Ito - https://metacpan.org/author/TOSHIOITO
