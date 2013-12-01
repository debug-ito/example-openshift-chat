## This script is executed to set environment variables for control
## actions such as starting and stopping your app.

## See https://metacpan.org/pod/plackup for detail.


$ENV{PLACK_ENV} = "deployment";

## If you prefer Starman, for example, uncomment the following line
## and put "require 'Starman';" into cpanfile.

$ENV{PLACK_SERVER} = "Twiggy";
