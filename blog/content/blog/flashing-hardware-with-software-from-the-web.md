+++
title = "Flashing hardware with software from the web"
author = ["Hippie Hacker"]
date = 2017-01-04
lastmod = 2017-01-04T15:00:02+13:00
tags = ["kubernetes", "cloud"]
categories = ["guides"]
draft = false
summary = "It's possible to flash hardware from the web"
+++


## It's possible to flash hardware from the web

Getting custom software onto hardware is hard. Particularly if you want people to be able to modify, change, and share that software. It can be as easy visiting a web page, connecting our devices, and loading our customized versions.

[flash.getchip.com](http://flash.getchip.com/)
uses the [C.H.I.P. Flasher
chrome-plugin](https://chrome.google.com/webstore/detail/chip-flasher/bpohdfcdfghdcgflomadkijfdgalcgoi)

Most AllWinner [boot roms](http://linux-sunxi.org/BROM) detect when a uboot pin
is connected to ground. This forces the devices into [FEL
mode](http://linux-sunxi.org/FEL) to support flashing. On the
[C.H.I.P.](https://getchip.com/pages/chip), a physical paperclip can be used to
short the uboot/FEL pin.

## A paperclip or jumper wire is used to turn on write-mode

![jumper wire in correct place in chip](/images/2017/01/uboot_fel_jumper.jpg)

This allows the website + plugin to detect the C.H.I.P. and present valid images for flashing.

![image](/images/2017/01/Flasher-CHIP-Detected.png)

![image](/images/2017/01/Flasher-CHIP-details.png)

The images can be saved to disk and the plugin can be used offline to flash again.

> Flashing will download between 250MB-625MB of data. If you have a slow internet connection, it can take a very long time to finish. If your connection is slow, we recommend that you click on the "cloud" icon in the upper-right corner of the image you want, and download the file first. You can then use the "Choose a file..." option once it's downloaded.

## Currently only a few images are available

![image](/images/2017/01/Flasher-CHIP-image-selection-1.png)

**However this chrome plugin could be used with any custom OS image build pipeline to deploy directly to hardware from the web!**

We've took [resinOS](https://github.com/resin-os) and [ported it to the
C.H.I.P.](https://gitlab.ii.org.nz/iichip/resin-chip/blob/fastbuild/chip.json)
and think it would be useful to flash any AllWinner/FEL device directly from
gitlab or other ci automation pipeline web interface.

![image](/images/2017/01/resin-chip-build-1.png)

What if we could replace the _Download_ link with _Flash_ directly?

![image](/images/2017/01/resinos-chip-download.png)

## What's needed?

*   NextThingCo recently updated their
    [BuildRoot](https://github.com/NextThingCo/CHIP-buildroot) to [use a new
    image
    format](https://bbs.nextthing.co/t/new-chip-sdk-chip-tools-update/12980)
    which we still need to update our [resin port to
    C.H.I.P.](https://gitlab.ii.org.nz/iichip/resin-chip/issues/1)
    to use.
*   NextThingCo also [doesn't seem to
    publish](https://github.com/NextThingCo/CHIP-SDK/issues/18) the plugin
    source, but [we've pulled it out of the plugin to
    analyze](https://gitlab.ii.org.nz/iichip/CHIP-flasher-chromeplugin).
    We have a couple open tickets:
    *   [Locate NextThingCo src for CHIP-flasher chrome plugin](https://gitlab.ii.org.nz/iichip/iichip/issues/1)
    *   [Build, install, and use the upstream sunxi-fel-chrome-plugin to install firmware to an iiCHIP](https://gitlab.ii.org.nz/iichip/sunxi-fel-chrome-extension/issues/1)
    *   [Deliver forked CHIP images via a webpage](https://gitlab.ii.org.nz/iichip/iichip/issues/2).
