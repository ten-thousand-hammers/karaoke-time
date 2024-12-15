# README

## Setup

### Operating System

I've only tested this on a Raspberry Pi 4 Model B with 4 Gigs of ram. It may work on other systems however. Install Debian Linux 12 (bookworm), which should come with the Wayfire desktop.

I believe a standard install. I named my machine `karaoke` and it resolves to `karaoke.home` because my router is setup with a domain of `.home`.

During installation if the first user you create is called `karaoke`, you can skip the user creation step.

#### Dependencies

You'll need some apt dependencies, which you can install within a terminal.

```bash
apt install git chromium-browser
```

You also need to make sure you have ruby. I believe it's pre-installed and must be ruby 3.1.2. Because this is what my box installed, I haven't looked into changing it.

This will confirm what version you have.

```bash
ruby --version
```

The output should be something like this

```
ruby 3.1.2p20 (2022-04-12 revision 4491bb740a) [aarch64-linux-gnu]
```

#### Create a user to run the service

_Skip this if you already created a **karaoke** user in the OS install step_.

The installation will run a service persistently on the machine. I like to create a user and group to use for this. I'll simply call them **karaoke**.

```bash
sudo useradd -m -s /bin/bash karaoke
sudo groupadd karaoke
sudo usermod -aG karaoke karaoke
```

### Install Karaoke Time

#### Get the latest version

You'll want to grab the latest version of Karaoke Time and git clone it to `/opt/karaoke_time`. There are no releases right now since this is Alpha-level software.

```bash
git clone git@github.com:ten-thousand-hammers/karaoke-time.git /opt/karaoke_time
```

Make sure the new directory is permissioned as the `karaoke` user.

```bash
chown -R karaoke:karaoke /opt/karaoke_time
```

#### Login as Karaoke

The rest of the steps may go smoother if you're logged in as `karaoke`. You can either log in directly in the desktop or you can personate that user on the terminal with this command.

```bash
sudo su - karaoke
```

Then all future commands will use that user.

#### Update your ruby dependencies

From a terminal, cd into the karaoke_time directory and run bundle install.

```bash
cd /opt/karaoke_time
bundle install
```

#### Create the database

Karaoke Time relies on a small SQlite database that gets created directly in the `/opt/karaoke_time/storage` folder. You can create this using this command.

```bash
cd /opt/karaoke_time
./bin/rails db:create db:migrate
```

#### Generate the front-end assets

Now you need to generate some front-end assets that the web browser can serve. You can do this by running this command.

```bash
cd /opt/karaoke_time
./bin/rails assets:precompile
```

#### Generate a master key

For the system service below you'll need a **master key**, everyone's should be different and unknown to other. You can easily generate this in the terminal with this command

```bash
cd /opt/karaoke_time
./bin/rails secret
```

##### Create a system service to start and run Karaoke Time at boot

You want to create the file `/etc/systemd/system/karaoke.service` and insert these contents

```
[Unit]
Description=Karaoke Time

[Service]
User=karaoke
TimeoutStartSec=5min
Environment=RAILS_ENV=production
Environment=RAILS_MASTER_KEY={{ ADD YOUR MASTER KEY HERE }}
ExecStartPre=/bin/rm -f /opt/karaoke_time/tmp/pids/server.pid
ExecStart=/opt/karaoke_time/bin/rails server
WorkingDirectory=/opt/karaoke_time

[Install]
WantedBy=multi-user.target
```

Once you create this service file you have to inform systemd that it exists or has changed with this

```bash
systemctl daemon-reload
```

Then you can start the service using this command

```bash
systemctl start karaoke
```

You can check the status of the service by running

```bash
systemctl status karaoke
```

If everything is going well it should say its "active" and look similar to this.

```
● karaoke.service - Karaoke Time
     Loaded: loaded (/etc/systemd/system/karaoke.service; enabled; preset: enabled)
     Active: active (running) since Tue 2024-11-26 09:32:22 EST; 2 weeks 5 days ago
    Process: 1933577 ExecStartPre=/bin/rm -f /opt/karaoke_time/tmp/pids/server.pid (code=exited, status=0/SUCCESS)
   Main PID: 1933582 (ruby)
      Tasks: 88 (limit: 3910)
        CPU: 2h 13min 12.760s
     CGroup: /system.slice/karaoke.service
             ├─1933582 "puma 6.4.2 (tcp://0.0.0.0:3000) [karaoke_time]"
             ├─1933680 "puma: cluster worker 0: 1933582 [karaoke_time]"
             ├─1933693 "puma: cluster worker 1: 1933582 [karaoke_time]"
             ├─1933709 "puma: cluster worker 2: 1933582 [karaoke_time]"
             └─1933714 "puma: cluster worker 3: 1933582 [karaoke_time]"
```

If something goes wrong, let me know what it is. But if it's right you need to enable it so it starts at boot.

```bash
systemctl enable karaoke
```

### Kiosk Mode

The idea way I like to use this is for it to boot directly into a web browser in kiosk mode so this works more like an appliance and not a computer.

Let's go through some quick steps to do this

#### Auto login as the karaoke user

Setup the karaoke user to auto login. You may be able to do this during OS install. If not, we can add instructions here. I don't know how to do it off the otp of my head.

#### Start Chromium at Boot

You can modify the wayfire.ini to auto boot chromium on your service.

Edit the file `/home/karaoke/.config/wayfire.ini` and go to the `[autostart]` section, or create one if it doesn't exist. Add 1 item there

Replace the **192.168.1.2** with your own IP address below. I'd suggest making sure this machine has a static IP so this doesn't rotate

```
[autostart]
1 = /usr/bin/chromium-browser http://192.168.1.2:3000/splash --start-maximized --autoplay-policy=no-user-gesture-required --kiosk --incognito --noerrdialogs --disable-translate --no-first-run --fast --fast-start --disable-infobars --disable-features=TranslateUI --ozone-platform=wayland --enable-features=OverlayScrollbar --disk-cache-dir=/dev/null --overscroll-history-navigation=0 --disable-pinch
```

Save that file and you should be good to go. Try to restart the computer and see if it starts up and loads karaoke time.
