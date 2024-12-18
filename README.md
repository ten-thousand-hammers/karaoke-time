# README

## Setup

### Operating System

I've only tested this on a Raspberry Pi 4 Model B with 4 Gigs of ram. It may work on other systems however. Install Raspbian OS or possibly Debian Linux 12 (bookworm), which should come with the Wayfire desktop.

### Install Karaoke Time

#### Get the latest version

Download the latest release from here: https://github.com/ten-thousand-hammers/karaoke-time/releases

Find the karaoke-time-0.1.2-arm64.deb file, download it and either double-click or run this command to install

```bash
dpkg -i karaoke-time-0.1.2-arm64.deb
```

This will create a `karaoke-time` user and setup the local database as well as start the service in the background. It will run on port 3000 and you should be able to access the server after install by using this url

http://127.0.0.1:3000

### Kiosk Mode

The ideal way I like to use this is for it to boot directly into a web browser in kiosk mode so this works more like an appliance and not a computer.

Let's go through some quick steps to do this

#### Enable wayland

The instructions below are for Wayland using the Wayfire desktop. It's possible it's not enabled on yours, so to do that you can go here.

```
raspi-config
```

On the menu go to Advanced -> Wayland and then choose the Wayland desktop.

https://raspberrypi.stackexchange.com/questions/144866/can-i-use-x11-on-the-new-64-bit-os-instead-of-wayland/144867#144867

It should ask you to restart after this is done.

#### Change your resolution

If you have a 4K TV, this can struggle with performance at that resolution. I would recommend changing your resolution down to 1920x1980.

https://raspberrytips.com/change-resolution-raspberry-pi/

#### Auto login as the karaoke user

Make sure that it's automatically logging in the user you created when you installed the OS.

#### Start Chromium at Boot

You can modify the wayfire.ini to auto boot chromium on your service.

_replace karaoke with whatever username you used when installing the os_

Edit the file `/home/karaoke/.config/wayfire.ini` and go to the `[autostart]` section, or create one if it doesn't exist. Add 1 item there

Replace the **192.168.1.2** with your own IP address below. I'd suggest making sure this machine has a static IP so this doesn't rotate

```
[autostart]
1 = /usr/bin/chromium-browser http://192.168.1.2:3000/splash --start-maximized --autoplay-policy=no-user-gesture-required --kiosk --incognito --noerrdialogs --disable-translate --no-first-run --fast --fast-start --disable-infobars --disable-features=TranslateUI --ozone-platform=wayland --enable-features=OverlayScrollbar --disk-cache-dir=/dev/null --overscroll-history-navigation=0 --disable-pinch
```

Save that file and you should be good to go. Try to restart the computer and see if it starts up and loads karaoke time.

## First Run

Once it's started up in the browser it's first going to test whether or not it can autoplay video. The computer is meant to be one that you don't have to touch. However, sometimes we can't force this autoplay. If it doesn't work, you have to click the **Confirm** button in order to get it to fully start up. If it works though, you'll hear some audio because it's autoplaying a small portion of Big Buck Bear.

### Loading it on your phone

It should be showing a barcode of a local IP address on the bottom left hand corner. Scan this with your phone and it should load up your web browser to the search interface.

### Updating yt-dlp

This program does require that you have a utility installed called `yt-dlp`. It's what we use to search and download youtube videos. However, YouTube doesn't like this and frequently breaks it. That means you have to have a very up to date version of yt-dlp to get around any of their latest changes.

I've built into the app a way to automatically download and update yt-dlp. Click on the settings gear at the bottom and click on **Update yt-dlp** and wait. It should update fairly quick to the latest _nightly version_.
