# reactorcide

A minimalist CI/CD system build in bash functions, which is all the glue one needs for cross-platform jobs

## Philosophy

We want to react to git events. Ultimately we want to have:
* An isolated run from a known state as much as is feasible
* A configuration for some knobs for the thing running the job (the CI/CD system, or reactorcide in this case)
* A configuration passed to the job itself (a PR workflow, a merge workflow, etc)
* No ties to the git host, so if say, this git host is down, we can still run reactorcide from a checkout on anything we can pass the environment to (bash)
* Functions to make some checks easier. Like, has the commit we've checked out already been tagged? With <foo> specifically? Those should just be function calls.
* Run the actual job inside a given docker container. We'll have standards of a "this is where the bash functions, and the env file is mounted, we'll run your entrypoint" style API

We might add some additional things later like a webhook-to-job API and a log capture mechanism or something. Secrets are a whole thing, a job queue is a whole thing. We're trying to be minimal so peeps (mostly us) can glue this up however they want.

## Status

Just beginning and playing. Join the [Catalyst Community Discord](https://discord.gg/sfNb9xRjPn) to chat about it.

If you want to try it, the goal is you have to copy `external-root.sh` to somewhere that has git, curl, and docker (curl is unused at the moment) and then you can setup your system however you want to. For instance, if I were running from some other CICD system, in that system I would do:

```bash
# runnerenv.sh is the host that sets up the job, used by external-root.sh
scp [-p port] runnerenv.sh jobenv.sh user@host
# remember that external-root.sh is already on that box, though you could copy it if you wanted
ssh user@host external-root.sh
```

Any other way you want to get `runnerenv.sh` and `jobenv.sh` to the host, you do you.

The env.sh files are just `VARNAME=VALUE` shell variables that configure the job. So your runnerenv configures the host, and the jobenv configures anything you need in the job itself. The job is just going to call a bash script of your choosing in that container running the job.

Simple, easy, hopefully very effective.
