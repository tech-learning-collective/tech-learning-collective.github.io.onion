# Tech Learning Collective's Onion site

This repository provides an automated build of the public [Tech Learning Collective Web site](https://techlearningcollective.com/) that is pre-configured to run as a [Tor Onion service](https://community.torproject.org/onion-services/), inside [Docker](https://www.docker.com/) containers, using a [Docker Compose](https://docs.docker.com/compose/) configuration. The configuration provides three main services, and one ancillary service:

* `ssg`, the [static site generator](https://www.staticgen.com/), takes the public Web site's [Jekyll](https://jekyllrb.com/) templates and runs them through [`jekyll build`](https://jekyllrb.com/docs/usage/) to generate the site's complete HTML, JavaScript, and CSS source code files.
* `web`, the HTTP server, is a simple [Nginx](https://www.nginx.com/) container that serves the static files generated earlier. The `ssg` and `web` services share a subset of files so that whenever the `ssg` container builds new source code, the Web server begins serving them.
* `tor`, the Tor Onion service server, provides a gateway to the Web server via a reverse proxy from the [Tor](https://torproject.org/) network. This makes it possible to serve the Web site from a computer behind a NAT or a strict firewall, as long as it can make a connection to the Tor network.
* `watchtower`, the ancillary service included to ensure that the base container image of the `web` and `tor` services are updated in a reasonable timeframe after updates and patches are made available for them, without requiring any further action on the part of human operators.

All of these are technologies that Tech Learning Collective instructors teach during [courses](https://techlearningcollective.com/courses/) and [workshops](https://techlearningcollective.com/workshops/). Please check us out if you want to learn more!

## How to run your own Tech Learning Collective mirror Onion site

You can use this project to practice using any of the technologies mentioned above, to help us proliferate our content, or just to have fun. Here's how. The whole process, in a nutshell, goes like this:

1. [Install preqrequisite software](#install-prerequisite-software)
1. [Download required source code](#download-required-source-code)
1. [Run `docker-compose up` to spin up the mirror site](#run-docker-compose-up-to-spin-up-the-mirror-site)

### Install prerequisite software

First, you'll need to make sure your computer has the required software installed:

1. Git: you can find a great [Git installation guide](https://github.com/git-guides/install-git) from the team at GitHub.
1. Docker:
    * **macOS** or **Windows** users should download the [Docker Desktop](https://www.docker.com/products/docker-desktop) version for their Operating System.
    * **GNU/Linux** users should follow the instructions for installing the Linux [Docker Engine](https://docs.docker.com/engine/install/#server) server.
1. Docker Compose:
    * **macOS** or **Windows** users are already set, because Compose ships with Docker Desktop.
    * GNU/Linux users will probably need to take these few extra steps to [install Compose on Linux](https://docs.docker.com/compose/install/).

### Download required source code

Once you have the prerequisite software, you next need to download the source code and configurations contained in this repository.

We use a [Git submodule](https://git-scm.com/book/en/v2/Git-Tools-Submodules) to manage the source code for the Web site independently from this mirror Tor Onion site configuration. This allows us to modify both components independently. It also makes it super easy to use this same configuration to create a Tor Onion site based on some other statically-generated Web site other than our own.

To download both this repository and the code referenced by the submodule, use the following command invocation:

```sh
git clone --recursive https://github.com/tech-learning-collective/tech-learning-collective.github.io.onion.git
```

> :beginner: If command line interfaces (CLIs) are new to you, consider spending some time at our totally free "[Foundations: Command Line Basics](https://techlearningcollective.com/foundations/#foundations-command-line-basics)" course, available from our Web site.
>
> :bulb: If the above command takes too long or uses too much disk space on your computer, you can optimize things by truncating the revision history with something known as a "shallow" Git clone, like this:
>
> ```sh
> git clone --recursive --depth 1 --shallow-submodules https://github.com/tech-learning-collective/tech-learning-collective.github.io.onion.git
> ```

The above command will have created a folder called `tech-learning-collective.github.io.onion` for you. Go there with the following command:

```sh
cd tech-learning-collective.github.io.onion
```

You're now ready to generate the Web site and start serving it as a Tor Onion service.

### Run `docker-compose up` to spin up the mirror site

The [`docker-compose.yaml`](docker-compose.yaml) file contains a description of how the three different microservices (the static site generator, the Web server, and the Tor server) work together. This description contains the details about what commands to run, where to mount certain files and directories, which network ports should be used, and more. All you have to do is tell Docker to do its thing.

The simplest way to do that is with this command invocation:

```sh
docker-compose up
```

This will build all three containers, create a network for them to connect to one another, and run them while attached to that network.

> :beginner: If you see an error like this...
>
> ```
> ERROR: Couldn't connect to Docker daemon at http+docker://localunixsocket - is it running?
> ```
>
> ...try running the command with elevated privileges, such as with the `sudo` command, `sudo docker-compose up`, if you're on Linux.

You'll see a *lot* of output scroll by as the containers start up and do their thing. Some important lines to notice are:

* the Onion address of your new Tor Onion site. It will look something like this:
    ```
    tor_1  | Entrypoint INFO     web: fdxwfyygp2ctzemwyogxex7su227tmiruascinayzeyrtb5kvj5rylad.onion:80 
    ```
    Of course, the random-looking string of text before `.onion` will look different for you. That's your new Onion addres. Go ahead and [download a copy of the Tor Browser](https://www.torproject.org/download/) if you don't already have it, then try going to the Onion domain shown in the output of your terminal.
* indication that the Web site has been generated successfully. That will be a line that exactly matches this:
    ```
    techlearningcollectivegithubioonion_ssg_1 exited with code 0
    ```
    When a computer program exits "with code `0`" (zero), it's telling that it thinks it's done its job successfully. Don't be disappointed if the Onion site doesn't show up exactly right until you see this line appear. It can take some time!

That's it! You're running a copy of our public Web site as a Tor Onion site. You've just made the Dark Web a little bit bigger, and a little bit queerer. :)

If you ever want to update your copy with the latest changes we make to our Web site, such as new event listings or blog posts we add, you merely need to run these two invocations again:

```sh
cd src && git pull              # In the "source" directory, pull in new changes.
cd ..  && docker-compose up ssg # Back in the main directory, run the `ssg` container again.
```

To keep your copy of the site updated automatically, you can put these commands in a shell script and run the script on a schedule by using any number of scheduling tools, such as the famous UNIX [`cron`](https://en.wikipedia.org/wiki/Cron) utility.

## Come to a Tech Learning Collective workshop!

Had fun? Had trouble? Want to learn more? Join us at any of these relevant Tech Learning Collective workshops:

* [Collaboration Across Universes: Basics of Version Control with Git](https://techlearningcollective.com/workshops/Collaboration-Across-Universes-Basics-of-Version-Control-with-Git)
* [Clearing Away the Clouds: How Computer Networks, Servers, and the Internet Work](https://techlearningcollective.com/workshops/Clearing-Away-the-Clouds-How-Computer-Networks,-Servers,-and-the-Internet-Work)
* [The Web as a Language: What No One Ever Told You About HTML That You Didn't Know To Ask](https://techlearningcollective.com/workshops/The-Web-as-a-Language-What-No-One-Ever-Told-You-About-HTML-That-You-Didn't-Know-To-Ask)
* [Ship Shape Computing: Working with Containers and Containerizing Digital Workloads](https://techlearningcollective.com/workshops/Ship-Shape-Computing-Working-with-Containers-and-Containzerizing-Digital-Workloads)
* [Tor: What is it Good For? (Absolutely Everything!)](https://techlearningcollective.com/workshops/Tor-What-is-it-Good-For-(Absolutely-Everything!))
* [Writing with Blue Fire: Shell Scripting for Beginners](https://techlearningcollective.com/workshops/Writing-with-Blue-Fire-Shell-Scripting-for-Beginners)

You can also learn more about Tech Learning Collective from [our blog](https://techlearningcollective.com/blog/).
