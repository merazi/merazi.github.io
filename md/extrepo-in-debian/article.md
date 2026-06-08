---
title: Extrepo in Debian
date: 2026-06-07 18:37:01
---

Hey there! `extrepo` is a handy tool for Debian users who want to add and manage third‑party APT repositories cleanly. It provides a consistent, Debian‑friendly way to discover, enable, disable, and update external repositories (e.g., third‑party projects that provide Debian packages such as LibreWolf, Steam, VirtualBox, etc.).

If you want the authoritative reference, consult `man extrepo`, but here’s a concise, practical introduction.

## Installation

`extrepo` is available from Debian’s official package archive. You can check the package listing and available versions on Debian’s package search (search for "`extrepo`" on the packages site).

Example install:
```bash
sudo apt update
sudo apt install extrepo
```

## Basic usage

Common extrepo commands (from the tool’s help output) include:

```bash
/usr/bin/extrepo search     # search for repositories
/usr/bin/extrepo update     # update a repository's metadata
/usr/bin/extrepo disable    # disable an extrepo-configured repository
/usr/bin/extrepo enable     # (re-)enable an extrepo repository
```

Useful options:

- `--url <url>`: define URL where to fetch extrepo data
- `--offlinedata`: use offline data provided by the extrepo-offline-data package
- `--mirror <mirror>`: use a specific mirror URL

## Finding available repositories

To list all repository names `extrepo` knows about, this command works (it performs an empty search and extracts names from the output):

```bash
extrepo search | grep ^Found | awk '{print $2}' | sort
```

While it may not be the most elegant solution, it works; you can adapt it or parse extrepo's output programmatically if you prefer.

## Examples of packages/repos

Projects that commonly provide repositories and that people add via `extrepo` include:
- VirtualBox
- Steam (Valve)
- LibreWolf
- Tor Browser

Note: availability depends on the `extrepo` data feed and the package maintainers. If a project doesn’t appear, check that the upstream provides a Debian repository and that extrepo’s data source includes it.

## Non‑free software

`extrepo` supports enabling repositories that contain non‑DFSG‑free software, but Debian’s apt sources and APT policy still apply. To enable contrib/non‑free in extrepo’s default configuration, edit `/etc/extrepo/config.yaml` and enable those policies:

```yaml
---
url: https://extrepo-team.pages.debian.net/extrepo-data
dist: debian
version: trixie
# To enable repositories that host software with non-DFSG-free licenses,
# uncomment "contrib" and/or "non-free" in the list below.
enabled_policies:
- main
- contrib
- non-free
```

After enabling, you can enable relevant third‑party repos (for example, repos that offer NVIDIA drivers). Remember that enabling non‑free repositories may bring software that is not DFSG‑free and may have different support or licensing considerations.

## Safety and best practices

- Inspect the repository information before enabling it. Prefer repositories maintained by the upstream project or trusted maintainers.
- Use extrepo’s metadata (URLs and keys) rather than manually adding arbitrary APT lines from random web pages.
- After enabling a third‑party repo, review package signatures and the repository’s signing key.
- Read upstream docs for any post‑install steps (e.g., adding your user to groups like `vboxusers` or `kvm` for virtualbox or virt-manager respectively).

## Further reading

- `man extrepo`: local manual (run `man extrepo`)
- [extrepo package page](https://packages.debian.org/search?keywords=extrepo&searchon=names&suite=all&section=all)
- [Debian Social Contract & DFSG](https://www.debian.org/social_contract#guidelines)
- [Don't Break Debian](https://wiki.debian.org/DontBreakDebian/)

## Final thoughts

`extrepo` is a small but useful tool as it centralizes discovery and management of third‑party Debian repositories, encouraging more Debian‑compliant installs and reducing manual changes to your APT configuration. If you use third‑party repos often, it’s worth trying.

Thanks for reading!