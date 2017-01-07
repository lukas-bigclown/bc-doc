# Raspberry Pi - Installation

{% set raspbian-zip = "bc-raspbian-v1.0.1-armhf-rpi.zip" %}
{% set raspbian-img = "bc-raspbian-v1.0.1-armhf-rpi.img" %}
{% set note-sudo = "“sudo” means the process will start with administrator privileges and may require your account password (if you are eligible for administrator rights)." %}

> If you already have your Raspberry Pi with Raspbian running on it, you can skip to [Install BigClown packages on existing system](#install-bigclown-packages-on-existing-system) to see how to install BigClown packages to your existing system.

This tutorial will guide you through a step-by-step installation procedure of Raspberry Pi.
It has been tested on Raspberry Pi 3 (Model B) but it will probably work on Raspberry Pi 2 as well.

We will install BigClown's version of Raspbian - the official and the most popular Linux distribution for Raspberry Pi.


## What is needed?

* Raspberry Pi 3 (Model B)
* Minimum 4 GB MicroSD card
* MicroSD card reader
* Ethernet cable
* Desktop or laptop PC
* Router (or LAN switch) with configured DHCP server
* Operating system with one of these:
  * Windows 7, 8.x, 10 (32-bit or 64-bit version)
  * macOS (tested with 10.12.1)
  * Linux (tested with Ubuntu 16.04 LTS)


## Prepare the MicroSD card

1. Insert the MicroSD card to the MicroSD card reader.

2. Download the latest release of BigClown's Raspbian image from [this link](https://github.com/bigclownlabs/bc-raspbian/releases/download/v1.0.1/{{ raspbian-zip }}).


### On Windows desktop

3. Unzip the downloaded image.

   You can use http://www.7-zip.org[7-Zip] to do it.

4. Write `{{ raspbian-img }}` to the MicroSD card.

   You can use https://sourceforge.net/projects/win32diskimager/files/latest/download[Win32 Disk Imager] to do it.

   > Win32 Disk Imager must be run under administrator privileges.


### On macOS desktop

3. Open Terminal and navigate to your folder with downloads, for example:

   ```
   cd ~/Downloads
   ```

4. Unzip the downloaded image:

   ```
   unzip {{ raspbian-zip }}
   ```

5. Insert the MicroSD card to your Mac and find out what is the disk identifier (it will be /dev/diskX):

   ```
   diskutil list
   ```

6. You have to unmount the disk (replace X with the appropriate identifier):

   ```
   diskutil unmountDisk /dev/diskX
   ```

7. Write the image to the MicroSD card (replace X with the appropriate identifier):

   ```
   sudo dd if={{ raspbian-img }} of=/dev/rdiskX bs=1m
   ```

   > {{ note-sudo }}

  This will take some time.
  If you get a “permission denied” message, please make sure your MicroSD card is not write-protected (e.g. by SD card adapter).

8. Eject the card (replace X with the appropriate identifier):

   ```
   diskutil eject /dev/diskX
   ```


### On Linux desktop

3. Open Terminal and navigate to your folder with downloads, for example:

   ```
   cd ~/Downloads
   ```

4. Unzip the downloaded image:

   ```
   unzip {{ raspbian-zip }}
   ```

5. Insert the MicroSD card to your Linux desktop and find out what is the disk identifier (it will be /dev/sdX):

   ```
   lsblk
   ```

6. You have to unmount all disk partitions (replace X with the appropriate identifier):

   ```
   sudo umount /dev/sdX?
   ```

   > {{ note-sudo }}

7. Write the image to the card (replace X with the appropriate identifier):

   ```
   sudo dd if={{ raspbian-img }} of=/dev/sdX bs=1M status=progress
   ```

   This will take some time.
   If you get a “permission denied” message, please make sure your MicroSD card is not write-protected (e.g. by an SD card adapter).

8. Eject the MicroSD card (replace X with the appropriate identifier):

   ```
   eject /dev/sdX
   ```


## Start Raspberry Pi

1. Insert the MicroSD card to Raspberry Pi.

2. Connect the Ethernet cable to Raspberry Pi.

3. Connect the USB power adapter to Raspberry Pi.


## Log-in to Raspberry Pi

Next step is to login to Raspberry Pi via SSH terminal.

You can access the device in two ways:

 1. Using IP address (you have to determine what is the assigned address from the DHCP server).

 2. Using zeroconf mechanism by accessing `hub.local` host (this mechanism should work on any recent desktop).


### On Windows desktop

1. Download http://www.chiark.greenend.org.uk/~sgtatham/putty/download.html[PuTTY].

2. Open PuTTY and open SSH session:

   * Use hostname: `hub.local` or *IP address of Raspberry Pi*

   * Use login: `pi`

   * Use password: `raspberry`


### On OS X & Linux desktop

1. Open Terminal and connect to Raspberry Pi:

   1. using IP address:

      ```
      ssh pi@(IP address of Raspberry Pi)
      ```

   2. or using zeroconf name:

      ```
      ssh pi@hub.local
      ```

   3. Enter password: `raspberry`


## Update your installation

At the first time you log in do NOT forget to change the default password.
You can do it with the following command:

```
passwd
```

For security and stability reasons it is wise to keep your system updated.

Run this command to update the system:

```
sudo apt-get update && sudo apt-get upgrade
```


## Differences from the official Raspbian

Why have we created our own deployment of Raspbian distribution?
We wanted to simplify the installation process for users and automate some of our own stuff (we use Travis CI for automation).

This is a brief description of changes:

* Hostname is `hub` instead of `raspberrypi`.

* Timezone is set to Europe/Prague.

* The following repositories have been added to APT sources:

  * https://repo.bigclown.com
  * https://apt.dockerproject.org/repo

* Installed packages:

  * mosquitto
  * mosquitto-clients
  * docker
  * htop
  * git
  * python3.4
  * python3-paho-mqtt
  * python3-venv
  * python3-pip
  * bc-common
  * bc-gateway
  * bc-workroom-led-strip
  * bc-workroom-blynk


## Install BigClown packages on existing system

> Follow this procedure only if you have already running Raspberry Pi with Raspbian distribution on it and you have skipped all the previous steps.

1. Log in to SSH terminal.

2. Add BigClown APT repository to sources list:

   ```
   sudo sh -c 'echo "deb https://repo.bigclown.com/debian jessie main" >/etc/apt/sources.list.d/bigclown.list'
   ```

3. Start APT PGP key installation process:

   ```
   sudo apt-key add -
   ```

4. Copy the following block to clipboard and paste it to terminal:

   ```
   -----BEGIN PGP PUBLIC KEY BLOCK-----
   Version: GnuPG v1

   mQENBFhTX8MBCACl/4PIfFQI6A3q2nN9VD7URLxzitAzVGI3qzRiiKxeiuMqaAnc
   TVS+FsNac/8sWVXmfh1Umhov5z6I4zg67/In+h6dkmbrCu8Ii6f7qlaIIqp2h3+y
   Et3CVDy8lYaciq7hnIcmHUJmJ/tx99AX8Mf+WdLHOwM7XkdkfoWN5GCX+MOfoYuh
   xAdYrRMFNgXyV7ZB8BTZLV2nrd2ZnoQGq59KxhfsCniG+ONL/XIkKTRRaFRP7pZy
   wAazHyoWA1vC4bu3fGr2uzhw2UuhnlTyYL1K2OaE8aamBBzv44N7osrKmrIqxH/1
   Fx7Gi7K/24uso/mvRXhoEQKGQm/nwy9FLMQFABEBAAG0P0JpZ0Nsb3duIExhYnMg
   KEtleSBmb3Igc2lnbmluZyBwYWNrYWdlcykgPHN1cHBvcnRAYmlnY2xvd24uY29t
   PokBPQQTAQoAJwUCWFNfwwIbAwUJEswDAAULCQgHAwUVCgkICwUWAwIBAAIeAQIX
   gAAKCRBgUdWrLVBRSyVkB/0fL4VcSsl+15rcHTTu4QH2d6pvnuEZDrDqgzoSeoH0
   oH5O1HKx0m6fL9S2947W8eIJKdSUL+AH82qtI2HrfCyHg1JZfTb3fB+cFxU31wfb
   bE1CzP//WW7xWvd5HbbA8PuvMPMDt1NtBiETDEsJAKE2rzV7psD4e1ZER5Kf65sQ
   vTsJKkhC5gyZKNMm4lBzgJEiO1YMmRhg5qjuZbJ1JsE55ZbxEpZUB4ymU4jXijzr
   jNU3FOHlCxDue9IdYTpA/dYlSbRgK/2amF3J/FIkCJ6imKfup3kooDkNM9Gq/lfK
   j90SHmKdGgYdLvGGEo7o8nyAogqMaPpvEEYsa3Vxejx8uQENBFhTX8MBCADkOF8f
   d261IksPxtNPZBiTRwkjf3+/cdaaT1ERcjc3rWPsnqhGIzZC8el0dh2dTbnd0bLP
   OHxKciKUvy4WtE5KrQXVaS29E7Y5JteQQf3XNeCELRcQkHBmISXnV2MTGylulxzn
   tuuYS3EysvcSkx0pxETCiZnF3pmnWRhZTjz2y5cR9Sty40HFvPoSMLMvrYLhM4cO
   xoz3pO/YE2B3oeou+mzyz7/ojAelNRop/0rRIszwWn1cRfq6ctA6cYnL1+QfMusr
   hTL5VvlWTuHGEXlJBt8YBqZdevoDRWuJvQOwmDKp9IYsIqdvhTYrjnfz5M557Dpz
   npYrNtIz9oomC3IDABEBAAGJASUEGAEKAA8FAlhTX8MCGwwFCRLMAwAACgkQYFHV
   qy1QUUuUqAf9FR/eXnAVBa2r5wiZgsX5R4xztFwyXNst7jiVerN4/XHnXD9u0h7Y
   F+i+EPaykRM489v8iC7dXDgbUnnsmAuA3DOEzdZzEveAs4m27fhB8lKq/3DjvyRP
   fm5oLhoS1IlCoXPY4C20FWrX64vwPwmYqTPcMFjhdTdbhV/MueFMKGxtrxtuhm9J
   tt5wMmjN3F0clpQa+zhCFDMzjAJN1L4PM/wPpyake5BZ/2KotVRHtw8fkOgIKeCu
   omjViitWs41H3J8mVNZzFV/BTsli4HkIYbnXEQOFvSLZRUPju7dvgxvBEMbJAULw
   BzgkAJGkucF6sgAXx5QiItVAbyLb668+/Q==
   =+XAF
   -----END PGP PUBLIC KEY BLOCK-----
   ```

5. Now press Enter and then press Ctrl+D. You should see an `OK` response in terminal.

6. Update your existing installation:

   ```
   sudo apt-get update && sudo apt-get upgrade
   ```

7. Now you can install the individual packages:

   * Basic package for Workroom project (hardware interface):

     ```
     sudo apt-get install bc-workroom-gateway
     ```

   * LED strip plugin for Workroom project:

     ```
     sudo apt-get install bc-workroom-led-strip
     ```

   * Blynk plugin for Workroom project:

     ```
     sudo apt-get install bc-workroom-blynk
     ```
