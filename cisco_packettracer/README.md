# cisco_packettracer

The cisco **packettracer** is needed for the following course:
- https://www.netacad.com/courses/getting-started-cisco-packet-tracer?courseLang=en-US

The application is free to download here (if the link changes try to search for it...):
- https://www.netacad.com/resources/lab-downloads?courseLang=en-US

They provide only [ubuntu](https://ubuntu.com) package and I definitely don't
want to run this bloat directly on my machine even if I was ubuntu user.

**I made this so I can run the program on any linux inside a container.**

## Docker vs Podman

I will be using [docker](https://www.docker.com/) (actually
[podman](https://podman.io/)) to deploy and run this - but docker might work
too as is - if not let me know via [issue](https://github.com/ospalax/bitsnips/issues).

I don't want any container bloat to fill up my desktop storage and so
I&nbsp;actually have all container images on **ephemeral** storage - meaning it
will get deleted (after reboot)...

So that is reflected in how this thing is used:

1. build and store the image (as archive)
1. load the image (to local repository)
1. run container (from the image)

## Important (!)

Cisco requires you to login upon the start of that thing and it will try to open browser (any browser):

```
/usr/bin/xdg-open: 882: x-www-browser: not found
/usr/bin/xdg-open: 882: firefox: not found
/usr/bin/xdg-open: 882: iceweasel: not found
/usr/bin/xdg-open: 882: seamonkey: not found
/usr/bin/xdg-open: 882: mozilla: not found
/usr/bin/xdg-open: 882: epiphany: not found
/usr/bin/xdg-open: 882: konqueror: not found
/usr/bin/xdg-open: 882: chromium: not found
/usr/bin/xdg-open: 882: chromium-browser: not found
/usr/bin/xdg-open: 882: google-chrome: not found
/usr/bin/xdg-open: 882: www-browser: not found
/usr/bin/xdg-open: 882: links2: not found
/usr/bin/xdg-open: 882: elinks: not found
/usr/bin/xdg-open: 882: links: not found
/usr/bin/xdg-open: 882: lynx: not found
/usr/bin/xdg-open: 882: w3m: not found
xdg-open: no method available for opening 'https://auth.netacad.com
```

Obviously I did not want to install another bloated app inside the image and so I was curious if terminal browser will work...

**It does!**

I tried `elinks` and if you don't use the google account option but sign in directly then it works without javascript...

**Bravo!**

Yeah, it is little struggle to use...but it does the job and saves the space.

You can replace the `elinks` with other package inside the image if it bothers you.

**The terminal browser (any of them) will open in the same terminal as the docker
command - and it will be hidden behind the packettracer gui - so just switch
the windows if you don't see any browser popping up!**

## Quick Start

```
NAME
    cisco_packettracer.sh - tool to run cisco packettracer:

        1. more safely inside the container
        2. allows to run it on non-ubuntu distro

SYNOPSIS
    cisco_packettracer.sh [help]
        This help

    cisco_packettracer.sh build
        build the image - can be modified with the following variables:

        CISCO_FILE:
            path to the cisco package (must be inside the same directory as the
            Dockerfile...)

            default=download/CiscoPacketTracer_900_Ubuntu_64bit.deb

        UBUNTU_VERSION:
            change as needed - read the cisco documentation

            default=22.04

        BROWSER_APP:
            cisco will require to login via browser - this selects which
            browser to install (terminal browsers work too...)

            default=elinks

    cisco_packettracer.sh save [ARCHIVE]
        save the image to a archive - useful if you have ephemeral setup for
        container storage...

        ARCHIVE:
            path to the archive - works as argument and env. variable

            default=download/cisco_packettracer.tgz

    cisco_packettracer.sh load [ARCHIVE]
        load the saved image

        ARCHIVE:
            path to the archive - works as argument and env. variable

            default=download/cisco_packettracer.tgz

    cisco_packettracer.sh run
        simply start the container with the app (it must be built or loaded...)
```
