# Ubuntu 

## Steps after fresh install

1. Run update
    - system updates
    - update snaps
2. Configure terminal
3. Install KeePassXC from Snap
4. Sync Firefox


## Installing software

### apt

```bash
sudo apt install gnome-tweaks

sudo apt install git

sudo apt install dconf-editor

sudo apt install vlc # Snap package was not working on Lenovo T470
```

### .deb

- Miniconda / Anaconda


### Snap

Using the App Center the following software can easily be installed:

- [KeePassXC](https://keepassxc.org/download/#linux)
- [VS Code](https://snapcraft.io/code)
- Chromium
- VLC
- LibreOffice
- GIMP
- Darktable
- [Foliate](https://snapcraft.io/foliate) (epub reader)

It is also possible to install via terminal:

```bash
sudo snap install keepassxc

sudo snap install code --classic
```

To list and update all snap packages:

```bash
snap list

snap refresh --list

sudo snap refresh
```

### QGIS

- https://qgis.org/resources/installation-guide/#debian--ubuntu


### Nvidia drivers

"Software & Updates" --> "Additional Drivers"


## Tweaks and configuration

### Gnome Shell Extensions

```bash
sudo apt install gnome-shell-extension-manager
```

- Window Is Ready - Notification Remover


### Keyboard shortcut Power off

Adding shortcut for *Power off* screen by setting custom shortcut:

```gnome-session-quit --power-off```


### No lock screen after suspend

Open dconf editor: org -> gnome -> desktop -> screensaver -> ubuntu-lock-on-suspend


### Make header bar of windows "thinner"

Create a CSS file under `.config\gtk-3\gtk.css` with the following content:

```css
headerbar entry,
headerbar spinbutton,
headerbar button,
headerbar separator {
    margin-top: 0px; /* same as headerbar side padding for nicer proportions */
    margin-bottom: 0px;
    min-height: 20px;
}

headerbar {
    min-height: 20px;
    padding-left: 2px; /* same as childrens vertical margins for nicer proportions */
    padding-right: 2px;
    margin: 0px; /* same as headerbar side padding for nicer proportions */
    padding: 0px;
}
```

Press *Alt-F2* und type in `r` to make the changes effective.


### TLP – Linux Advanced Power Management

Documentation: https://linrunner.de

- Do not use it for newer Thinkpad models starting with T490
    - https://pointieststick.com/2020/06/08/lenovo-thinkpad-x1-yoga-impressions-bugs-workarounds-and-thoughts-about-the-future/

> For battery charging thresholds I recently dug into that a bit and got the following guidance from the battery team:
> – If you often discharge your battery to near eempty (< 20%) then start charging at 95% and stop at 100%
> – If you frequently use the battery but don't fully discharge. Usage between 50% and 100% then start charging at 75% and stop at 80%
> – If you always use an AC adapter and rarely use battery start charging at 45% and stop at 50%


```bash
sudo apt install tlp tlp-rdw

# for Thinkpads
tlp-stat -b #suggest which additional package to install

# bluetooth off at startup:
sudo nano /etc/tlp.conf

DEVICES_TO_DISABLE_ON_STARTUP="bluetooth"

# Akku-Ladeschwellen vorübergehend auf Maximum setzen
sudo tlp fullcharge [ BAT0 | BAT1 ]

# Akku einmalig bis zur oberen Schwelle laden
sudo tlp chargeonce [ BAT0 | BAT1 ]
```


## Tools

### PDF

#### Extracting photos from multiple PDFs using pdfunite and pdfimages

```bash
pdfunite *.pdf allphotos.pdf

pdfimages -j ‘allphotos.pdf’ image
```


## Troubleshooting

### Error: *Can't format USB storage*

I got this fixed by doing the following

Type disks and launch the program,
select the disk or drive you want to format,
press CTRL+F and click format.

After formatting, the disk or drive would be unallocated, therefore you'll have to create a partition by using the plus button on the screen.. Then insert the name you'll like to use as the drive or disk name then click on create. Enjoy....

https://askubuntu.com/questions/769079/cant-format-ubuntu-installation-stick/769094


## Unix shell

- http://swcarpentry.github.io/shell-novice/
- https://en.wikipedia.org/wiki/Bash_%28Unix_shell%29
- https://help.ubuntu.com/community/Beginners/BashScripting
