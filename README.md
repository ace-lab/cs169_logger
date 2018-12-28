# Logger Script

## Dependencies
* Listen gem (https://github.com/guard/listen)
* Git repository initialized

## How to use
Install the Listen gem into the repository (likely using Bundler and putting the Listen gem into the RoR repository's Gemfile). Then, place the logger.rb script into the initializers directory in the RoR app (/config/initializers). The script will load itself on the startup of the app in both development or test modes.

## How does the script function
The script creates and maintains a hidden directory (.log_cs169) used to keep all the log files generated from the repository over time. The script will create log events in two scenarios: 1) the user runs tests on the app or 2) the user keeps a Rails Server instance alive and saves changes to any file(s).

The script will then make a file within the logging directory (.log_cs169) that contains the output of a git diff from the immediately previous git commit, as well as the stats related to the diff (to make this information more machine-readable). This is the output from the --numstat flag on git diff (ex. "git diff --numstat").

## Structure of log file
Filename: "<timestamp>_<hash of latest commit on this branch>".
  
This structure was made to make sure that there would be no name collisions in the files leading to nasty git merge conflicts - especially as this is out of the app developers' workflow.

File:

<branch>, <Rails environment which triggered the log event>

<git diff output>

--

<git diff stats output>
