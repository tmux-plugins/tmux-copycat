## Tmux copycat test suite

This directory contains test files for tmux copycat.

Tests are written with the [expect tool](http://expect.sourceforge.net/).

### Dependencies

- [Vagrant](https://www.vagrantup.com/)

### Running the test suite

From the `tmux copycat` project top directory run:

    $ ./run-tests

### Debugging tests

In your tests, you can add a call to expect's interactive debugger with
``debug 1`` where you'd like to start debugging.

From the `tmux copycat` project top directory, bring up and access the given Vagrant VM:

    $ vagrant up [ubuntu|centos]
    $ vagrant ssh [ubuntu|centos]

and inside the VM, run the tests manually:

    $ cd /vagrant
    $ ./test/run-tests-within-vm

During this process, you can watch the progress of the tests interactively
by attaching yourself to the existing ``tmux`` server within the VM by
running ``tmux attach-session``.  Note that there may be multiple sessions
and windows in use, depending on how many times your tests have run, so
check through each until you find the applicable one.  Take care not to
disrupt the tests whilst running or you will encounter false results!

