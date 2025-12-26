---
title: Switching to the ICEWM window manager
date: 2025-12-25
---

I just wanted to write a quick blog on how I switched from XFCE4 to ICEWM.

Quick disclaimer, I do not dislike XFCE4 or anything like that, I just wanted to try something else.

I've used ICEWM in the past, however I never considered using it "seriously".

I hopped into the arch wiki and checked what was needed to be up and running with ICEWM, first I installed the package icewm from the archlinux official repos.

I also installed icewm-extra-themes from the AUR so I could get more theme options.

Once those two packages were installed, I uninstalled the xfce4 group entirely, as well as lightdm using these commands:

```sh
sudo pacman -Rncs xfce4
systemctl disable lightdm
systemctl stop lightdm
sudo pacman -Rncs lightdm
```

After that I rebooted and made sure I installed the `xorg-xinit` so I could use startx.

## ICEWM Session and startup apps

In order to have support for startup apps I did this in the `~/.xinitrc`:

```sh
exec icewm-session
```

I'm doing icewm-session instead of just icewm so I can later use the startup script mentioned in their docs: (https://ice-wm.org/man/icewm-startup.html)[https://ice-wm.org/man/icewm-startup.html].

Then in that startup file I have everything else, it's just a regular bash script:

```sh
#!/bin/bash

# start network manager
nm-applet &

# start bluetooth manager
blueman-applet &

# enable notifications
dunst &

# run conky system monitor
sleep 1 &&
        conky -c ~/.config/conky-date-widget &

# configuration for xter
xrdb -load ~/.Xresources

# set my wallpaper
icewmbg --center=1 -i ~/Pictures/1071432.png

# sticky notes support
xpad &

# enable compositing
xcompmgr &
```

Something worthy of mention is that I'm using `icewmbg` instead of something like `feh` of `nitrogen` for wallpapers, since it comes with ICEWM anyways.

## Dynamic Menu

For generating the dynamic menu I used `xdg-menu`, you can see more information about how to do it in the archwiki, it's quite simple: (https://wiki.archlinux.org/title/Xdg-menu#IceWM)[https://wiki.archlinux.org/title/Xdg-menu#IceWM].

## Screenshot

This is how my setup is working so far, I'll upload more blogposts if I have more updates. 

:-)

![Screenshot](./files/screenshot.png)
