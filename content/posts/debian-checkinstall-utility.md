---
title: "Debian checkinstall utility"
date: 2026-10-09
draft: false
tags: ["debian", "linux", "package-management", "sysadmin"]
description: "Why running make install is dangerous and how Debian's checkinstall utility keeps your system clean."
mastodon_url: "https://mastodon.social/@ttydweller/117426101554893763"
---

I recently ended up on Debian’s “Don’t Break Debian” page while looking for advice about installing software that isn’t available in the standard repositories. The page contains plenty of sensible warnings, including one about running `sudo make install` and hoping for the best.

That was where I discovered `checkinstall`. Debian recommends it as a better option when you need to compile a program from source but still want your installation to behave like a package. That sounded useful, because blindly copying files into `/usr/local` and then trying to remember what went where is not exactly a long-term system administration strategy.

## Why is make install a problem?

The usual process for compiling software from source looks something like this:

```bash
./configure
make
sudo make install
```

This works surprisingly often. The problem is that `make install` usually copies files directly into the filesystem. It may install binaries, libraries, manual pages, configuration files and other data, but it does not automatically create a Debian package that APT knows about.

As a result, APT and tools such as Synaptic generally have no idea that the software exists. You cannot reliably remove it with `apt remove`, and upgrading it later may leave old files behind. Some projects provide an `uninstall` target, but many do not.

There is also a more serious issue: software installed from source can overwrite files that belong to Debian packages or place files somewhere unexpected. It will not receive Debian’s normal security updates either. If the program is already available in the Debian repositories, installing the packaged version is usually the better choice.

## What checkinstall does

`checkinstall` sits in place of `make install`. It runs the installation command, keeps track of the files created or modified, and uses that information to build a package. On Debian, that package is normally a `.deb` file.

Instead of leaving behind a pile of files that only the original build system understands, you end up with something that can be inspected, installed and removed using normal Debian tools. The resulting package is also saved, so it can be installed again on another compatible machine without compiling the program from scratch.

That is the main reason checkinstall exists: it gives source-built software at least some of the housekeeping benefits of a package. It is not magic Debian packaging, but it is much tidier than pretending `make install` never happened.

## Installing checkinstall

Install it from Debian’s repositories:

```bash
sudo apt update
sudo apt install checkinstall
```

After that, build the software normally. The important difference is that you run `checkinstall` instead of `make install`.

## A basic example

Suppose the project uses the traditional Autotools build process:

```bash
tar -xf example-1.0.tar.gz
cd example-1.0
./configure
make
sudo checkinstall
```

When checkinstall starts, it will ask a few questions about the package. The defaults are often good enough, but it is worth checking the package name, version and description before accepting them.

Behind the scenes, checkinstall runs the installation step, records the files that are installed and creates a Debian package. It then installs that package on the system.

In many cases, the final command can be as simple as:

```bash
sudo checkinstall
```

If the project’s installation command is not `make install`, you can pass a different command to checkinstall. For example:

```bash
sudo checkinstall make install_modules
```

The exact command depends on the project’s build instructions. The general rule is simple: follow the project’s instructions up to the installation step, then replace that installation command with checkinstall.

## Removing the software later

Once the package has been installed, Debian can see it as a package rather than as a mysterious collection of manually copied files.

You can find the package name with:

```bash
dpkg -l | grep example
```

Then remove it with:

```bash
sudo apt remove example
```

You can also use `dpkg` directly:

```bash
sudo dpkg -r example
```

The exact package name may differ from the program’s command name, so checking the package list first is a good habit.

## Creating a package without installing it

Sometimes you only want to build the `.deb` file. In that case, use the `--install=no` option:

```bash
sudo checkinstall --install=no
```

This creates the package without installing it. You can then install it manually:

```bash
sudo dpkg -i example_1.0-1_amd64.deb
```

For a package with unmet dependencies, `gdebi` can help install required packages:

```bash
sudo gdebi example_1.0-1_amd64.deb
```

Packages created by checkinstall are generally intended for the same Debian release and architecture on which they were built. Copying them to a completely different system is not guaranteed to work.

## A few useful options

Checkinstall has quite a few options, and the manual page is worth reading:

```bash
man checkinstall
```

For additional information, see the [Debian Wiki page on CheckInstall](https://wiki.debian.org/CheckInstall/?pow_referer=https%3A%2F%2Fduckduckgo.com%2F).

Some commonly useful examples include:

```bash
sudo checkinstall --install=no
```
This builds the package but does not install it.

```bash
sudo checkinstall --pkgname=example --pkgversion=1.0
```
This lets you set the package name and version explicitly.

```bash
sudo checkinstall --backup=no
```
This disables the backup option if it is not needed. The available options can vary slightly depending on the installed version, so the local manual page is a better reference than a command copied from a ten-year-old forum post. Computer archaeology is a noble hobby, but it is not always a good deployment method.

## What checkinstall does not solve

Checkinstall is useful, but it should not be confused with creating a proper Debian package.

A package made with checkinstall may not contain accurate dependency information, integration scripts or all the metadata expected from a carefully maintained Debian package. It also does not magically turn third-party source code into software that receives Debian security updates.

It is best viewed as a practical tool for personal systems, testing, small utilities and software that you need to compile occasionally. It is less suitable for software that needs to be distributed widely or maintained as a polished Debian package.

You should also be careful about what you compile and install. Checkinstall tracks the installation process, but it does not audit the source code or guarantee that the build system is safe. It packages what the installation command does; it does not inspect the program’s intentions.

## When should you use it?

My preference would be:

1. Install the software from Debian’s repositories if it is available there.
2. Consider a backport or another well-maintained packaging option if the repository version is too old (for example, [Flatpaks](https://flatpak.org/)).
3. Use checkinstall when compiling from source is genuinely necessary and you want a straightforward way to remove the result later.
4. Use a container, virtual machine or another isolated environment when appropriate.
5. Learn proper Debian packaging if you plan to maintain or distribute the software long term. You can [start here](https://www.debian.org/doc/debian-policy/).

For a one-off source build, checkinstall is a useful middle ground. It preserves the flexibility of compiling software yourself while avoiding one of the biggest drawbacks of `make install`: forgetting what was installed and where.

It will not prevent every possible Debian disaster, and it does not replace good packaging practices. Still, compared with running `sudo make install` and hoping future-you remembers the cleanup procedure, it is a considerable improvement.

Sometimes the safest command is the one that leaves a paper trail. In this case, that paper trail happens to be a `.deb` file.

Thanks for reading!
