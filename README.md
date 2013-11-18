# OpenShift Cartridge for Plack/PSGI Perl application

The `plack` cartridge helps you create Perl Web applications based on
a pure Plack/PSGI infractructure. It uses `plackup` command to start
the PSGI server of your choice and runs your application on it.


## Structure

- app.psgi :
  Your PSGI application.
  
- cpanfile :
  List of CPAN modules that your application depends on.
  
- plack_config.pl :
  Script to set environment variables to control how "plackup" should work.
  
- lib/ :
  Your Perl module library. lib/ is automatically prepended to
  PERL5LIB environment variable.
  
- t/ :
  Directory your test scripts reside. *.t files are executed by
  "prove" command.
  
- .proverc :
  Options for "prove" command.


## Environment Variables

- OPENSHIFT_PLACK_LOG_DIR :
  Directory path in which you should store your log files. It is up to
  you to write and rotate logs in this directory. The log files are
  cleaned up by "rhc app tidy YOUR_APP_NAME" command.


## Module Management

CPAN modules are installed by `cpanm` tool.

- Directory ${OPENSHIFT_PLACK_DIR}.cpanm :
  Internal metadata and log files of `cpanm` are stored.

- Directory ${OPENSHIFT_PLACK_DIR}local :
  External CPAN modules are installed.


