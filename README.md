# goes-east-wallpaper-rpi
Program to set the current wallpaper for Raspberry Pi to the latest GOES East infrared and visible images.

# Setup:
1. Clone this repository.
1. From LXDE, set manually the wallpaper to ```/etc/alternatives/desktop-background```.
1. Edit ```get-visible-ir.sh``` and set:
   * ```base_folder``` to an existing folder that you want to save the acquired images from GOES East.
   * ```lat``` and ```lon``` to your location.
1. Create a line in crontab with the following (or similar) content. This example updates the wallpaper every 5 minutes:
   *  ```*/5 * * * *  /home/pi/goes-east-wallpaper-rpi/get-visible-ir.sh```
1. Profit (?)
