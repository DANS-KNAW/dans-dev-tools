dans-dev-tools
==============

DANS Development Tools.


SYNOPSIS
--------

    # Build and deploy cycle
    build-only-rpm.sh
    build-yum-repo.sh
    build-all.sh
    build-reprovision.sh
    build-all-and-reprovision.sh

    # Run with maven
    run-reset-env.sh
    run.sh [ <arg>... ]
    run-debug.sh [ <arg>... ]
    run-service.sh
    run-logback-statuslistener.sh [ <arg>... ]
    
DESCRIPTION
-----------
A set of simple wrappers for commonly used commands when developing a DANS module. There are two groups:
one dealing with the building the module and deploying it on a virtual machine that was previously started
with `vagrant`, the other with running the program locally in a debug session.

### `build*` scripts
The module should be buildable with a standard `mvn clean install`. This should result in the entire code base
being recompiled and repackaged as an RPM (if the `rpm` command was installed on your machine). However, on the
one hand this leaves reprovisioning of the project's virtual machine as an extra step, on the other hand it is 
often convenient to execute only part of the build cycle. The scripts listed below are provided to avoid having
to remember the exact invocations of Maven and ansible.

* `build-only-rpm.sh` - does *not* recompile the code base, but instead only repackages the currently compiled
   code in a new RPM package. 
* `build-yum-repo.sh` - does *not* recompile or repackage the code but merely copies the RPM already present
   in `target` to the VM's yum repository and updates the repository's metadata (or creates the yum repository,
   if it did not exist yet).
* `build-all.sh` - rebuilds and packages the code and also updates the yum repository. This assumes that the vagrant
   VM is up.
* `build-reprovision.sh` - only reprovisions the vagrant VM, so if there is un updated RPM in the yum repository it
   should be installed. The also assumed the vagrant VM is up.
* `build-all-and-reprovision.sh` - executes the whole build-and-provision cycle: it rebuilds the code, creates a new
   RPM, updates the yum repository with this RPM and then reprovisions the vagrant VM, so that the RPM is installed.

### `run*` scripts
These scripts run the program under development using the [exec-maven-plugin]. 

* `run-reset-env.sh` - the program needs a home directory in which to locate its configuration files and possibly
  other resources and a data directory for its input, output and logging. These are created as (git-ignored) directories
  in the project root. The application home directory is provisioned with the configuration files found in `src/test/debug-config`.
* `run.sh` - runs the program as a command line application.
* `run-debug.sh` - runs the program, starting the JVM as a debug server and suspending it so that you may attach your debugger
  (in IntelliJ: menu: `Run -> Attach to Local Process...`). Do yourself a favour and use this instead of creating run configurations
  in your IDE.
* `run-service.sh` - runs the program as a service. It expects to be able to do so by just running the command line application with
  the sub-command `run-service`. It starts the JVM as a debug server to which you can attach your debugger, but it does not suspend
  execution. (This is not necessary for a service, as it will wait for requests anyway and not run to completion - like a command line
  application.) This will use `home/cfg/logback-service.xml`, which should be configured to log to the console. You can then
  fire your requests from another terminal window with `curl` or maybe from a browser, depending on the type of service.
* `run-logback-statuslistener` - The same as `run.sh` except that it will print logback's internal status. You will only need this
  when you are having trouble with your logback configuration in this debug environment, so probably hardy ever.

[exec-maven-plugin]: http://www.mojohaus.org/exec-maven-plugin/index.html

### Assumptions
Some of the scripts make some assumptions about your project and the files in it. They will check those assumptions explicitly
and hopefully generate an intelligible message when running into problems. In general we assume that you are in the root directory
of a Maven project, that you are on a Mac (or maybe Linux?) and that `rpm` (and `rpmbuild`?) are installed.


ARGUMENTS
---------
Only some of the `run*` scripts accept arguments, namely the arguments for the program under development.


EXAMPLES
--------
Most of the scripts are fairly short, so inspect the code if you want to know what is going on.

Some examples of expected output.

    $ run-reset-env.sh
    Backing up existing data directory to data-2017-07-01@09:52:51...OK
    START: project specific initialization in ./debug-init-env.sh...
    Copying test bag stores to data...OK
    DONE: project specific initialization.
    
    The debug environment has been reinitialized.
    Application home directory at: home
    Data and logging directory at: data
    
    $ run.sh --help
    [INFO] Scanning for projects...
    [INFO]
    [INFO] ------------------------------------------------------------------------
    [INFO] Building Example Project 1.1.0-SNAPSHOT
    [INFO] ------------------------------------------------------------------------
    [INFO]
    [INFO] --- exec-maven-plugin:1.4.0:java (default-cli) @ example-project ---
    example-project v1.1.0-SNAPSHOT
    
    The Example Project
    
    ....


INSTALLATION AND CONFIGURATION
------------------------------
Clone this git repository to your local machine and put it on your `PATH`. Make sure
the scripts are executable.




    
