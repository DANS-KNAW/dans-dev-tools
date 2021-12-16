dans-dev-tools
==============

DANS Development Tools.

SYNOPSIS
--------

```bash    
# New style projects
start-env.sh
start.sh [ <arg>... ]
start-quiet.sh [ <arg>... ]
start-debug.sh [ <arg>... ]
start-service.sh 
start-hsqldb.sh 

# Legacy projects
run-reset-env.sh
run.sh [ <arg>... ]
run-debug.sh [ <arg>... ]
run-service.sh
run-logback-statuslistener.sh [ <arg>... ]
```

DESCRIPTION
-----------
A set of scripts around the [exec-maven-plugin], that allow you run your DANS module locally from within the Maven project. Each DANS module should contain two
directories immediately under the project root, that are ignored by git:

* `data/` - to store temporary test data that you use when test-driving your module.
* `etc/` - to store configuration files to use for you local test-driving sessions (**only new style projects**).
* `home/cfg/` - to store configuration files to use for you local test-driving sessions (**LEGACY: will be phased out**).

Note that there are two sets of scripts, `start*.sh` and `run*.sh`. They both have the same objective but expect slightly different project layouts. They will
fail in the other type of project, for example `start.sh`, when used in a legacy project, will fail with the message: 

> ERROR: this project contains a 'home'  directory. It is probably a legacy project. Use the run-*.sh scripts instead.
 
That is, if the project already contains the `home` directory, if it is a fresh
clone that was not initialized with `run-reset-env.sh` the failure may give a more obscure message.

### `start*.sh` scripts

* `start-env.sh` - this will create the `data/` and `etc/` directories. If `data/` already exists, it is backed up as `data-<timestamp>` and a new `data/`
  folder is created. The `etc/` folder is filled with the configuration files found in `src/test/debug-etc`.
* `start.sh` - starts the program a command line application. The configuration file `etc/config.yml` is passed in to use as default configuration for  
  custom subcommands subclassing [DefaultConfigEnvironmentCommand] or [DefaultConfigConfiguredCommand].
* `start-quiet.sh` - same as `start.sh`, but suppressed Maven output.
* `start-debug.sh` - same as `start.sh` but starting the JVM as a debug server and suspending it so that you may attach your debugger
  (in IntelliJ: menu: `Run -> Attach to Local Process...`). Do yourself a favour and use this instead of creating run configurations in your IDE.
* `start-service.sh` - starts the program as a service (with a JVM configured as debug server, but not suspending execution.

[DefaultConfigEnvironmentCommand]: https://dans-knaw.github.io/dans-java-utils/javadocs/nl/knaw/dans/lib/util/DefaultConfigEnvironmentCommand.html

[DefaultConfigConfiguredCommand]: https://dans-knaw.github.io/dans-java-utils/javadocs/nl/knaw/dans/lib/util/DefaultConfigConfiguredCommand.html

### `run*.sh` scripts (LEGACY)

* `run-reset-env.sh` - this will create the `data/` and `home/` directories. If `data/` already exists, it is backed up as `data-<timestamp>` and a new `data/`
  folder is created. The `home/cfg/` folder is filled with the configuration files found in `src/test/debug-cfg`.
* `run.sh` - runs the program as a command line application.
* `run-debug.sh` - runs the program, starting the JVM as a debug server and suspending it so that you may attach your debugger
  (in IntelliJ: menu: `Run -> Attach to Local Process...`). Do yourself a favour and use this instead of creating run configurations in your IDE.
* `run-service.sh` - runs the program as a service. It expects to be able to do so by just running the command line application with the
  sub-command `run-service`. It starts the JVM as a debug server to which you can attach your debugger, but it does not suspend execution. This is not necessary
  for a service, as it will wait for requests anyway and not run to completion - like a command line application. This will use `home/cfg/logback-service.xml`,
  which should be configured to log to the console. You can then fire your requests from another terminal window with `curl` or maybe from a browser, depending
  on the type of service.
* `run-logback-statuslistener` - The same as `run.sh` except that it will print logback's internal status. You will only need this when you are having trouble
  with your logback configuration in this debug environment, so probably hardly ever.

[exec-maven-plugin]: http://www.mojohaus.org/exec-maven-plugin/index.html

EXAMPLES
--------

```bash
# Starting with default config.yml (in etc/config) 
cd my-new-style-project
start.sh my-subcommand --some-arg 1 --some-option data/some-trailing-file-arg.txt
```

INSTALLATION AND CONFIGURATION
------------------------------
Clone this git repository to your local machine and put it on your `PATH`. Make sure the scripts are executable.

```bash
 cd ~/git/shared/
 git clone -o blessed https://github.com/DANS-KNAW/dans-dev-tools.git
 cd dans-dev-tools/
```    

Add this directory to you `PATH` environment variable:

```bash
vi ~/.zshrc
```  

Add the path to dans-dev-tools/ to PATH. You do this by adding a line like this:

```bash 
export PATH=$PATH:$HOME/git/shared/dans-dev-tools
```

Restart the commandline.
    
