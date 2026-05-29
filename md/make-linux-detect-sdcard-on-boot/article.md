---
title: Make Linux Detect SD Card On Boot
date: 2026-05-29 16:39:03
---

During my journey to get Arch Linux installed on an old Chromebook I had lying around, I stumbled upon an enormous brick wall: the limited storage of those devices.

Of course, a Chromebook is designed so you depend on Google services for file storage, so everything you do in a Chromebook will be stored in the cloud, with the occasional download here and there. Therefore, they didn't see the need to include much storage in those devices.

This is understandable for the regular user, but for me, it's unacceptable. I need more than 30GB for my files, packages, and such, so the limited space in the Chromebook was a problem when I decided to install Arch Linux on it.

The solution? An SD card that would serve as expanded storage. I got a cheap SD card with an additional 32GB capacity, which meant I had 62GB of storage to play around with, which is way better than only 30GB!

<a title="Thomas Kurpjuweit Tom Knox, CC BY-SA 4.0 &lt;https://creativecommons.org/licenses/by-sa/4.0&gt;, via Wikimedia Commons" href="https://commons.wikimedia.org/wiki/File:Fake_Micro_SD_Card.tif"><img width="330" alt="Fake Micro SD Card" src="https://upload.wikimedia.org/wikipedia/commons/thumb/9/99/Fake_Micro_SD_Card.tif/lossy-page1-330px-Fake_Micro_SD_Card.tif.jpg"></a>

It worked well for a while, until I became annoyed by having to disconnect and reconnect the SD card each time I wanted the laptop to detect it so I could mount it in my desktop environment. Every boot I had to do that over and over again, and it started to get old very quickly.

It was then that I said, "There has to be another way," so I started investigating. I eventually found a very hacky solution, thanks to the good folks at Libera.Chat's #archlinux channel.

The solution goes like this:

```bash
#!/bin/bash
echo "1" > /sys/bus/pci/devices/0000\:00\:1b.0/remove
echo "1" > /sys/bus/pci/rescan
```

This script tells the computer to "reset" the SD card slot. The first line makes the system forget the slot exists for a moment, and the second line tells it to look for it again. This basically tricks Linux into thinking you just plugged the card in, forcing it to detect it automatically during boot.

*Note: The code `0000:00:1b.0` is like a "home address" for my specific SD card slot. Your computer might use a different address, which you can find by running the `lspci` command in a terminal.*

Then it was just a matter of copying those two commands into a script which I named `fix-sdcard`, moved it to `/usr/local/bin/`, and then I created a systemd service that could run it on boot so each time I booted, the SD card would be "reinserted."

```ini
[Unit]
Description=Fix SD Card Configuration Service
After=local-fs.target

[Service]
Type=oneshot
ExecStart=/usr/local/bin/fix-sdcard
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
```

After all of that, I just configured my desktop environment's file manager (Thunar) to auto-mount the SD card on login using a simple `udisksctl` command.

Now I have a less-limited device to do all my writing, mobile work, and similar stuff.

Thanks for reading!
