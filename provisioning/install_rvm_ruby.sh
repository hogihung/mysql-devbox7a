# Install RVM and current Ruby (2.4.0 at the time of this creation)
gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB

# NOTE: As of 07/15/2017 @ 09:38pm EST, RVM is still bugged.  Use the work around solution below.
#\curl -sSL https://get.rvm.io | bash -s stable --ruby

# Work around solution for bug:  bash: line 880: __rvm_print_headline: command not found
curl -sSL https://get.rvm.io | grep -v __rvm_print_headline | bash -s stable --ruby


