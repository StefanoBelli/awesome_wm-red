# awesome_wm-red
Awesome WM red/dark theme plus config

*CHANGE POWEROFF AND REBOOT COMMAND FROM VARIABLES*
*TERMINAL KEYBINDING CHANGED TO: "Shift"+"Return"*

 This config works with:
  
  - Scrot 
  - Feh
  - XRandR 
  - Vicious

 Advised:
  
  - Vim 
  - URxvt

====
**THIS CONFIG MAY JUST WORK WITH GENTOO LINUX!**

Dark/Red theme for Awesome WM

 - Using rxvt-unicode (aka URxvt) as default terminal
 - Using Vim as default text editor
 - Added some options to main Awesome menu (Editor, Vim, Power off, reboot, Awesome...->Edit theme file)
 - Customized red icons with GIMP 
 - Added many keybinding
 - Change keyboard layout changing the value of keyboard_layout in config/rc.lua
 - Changed hex color value in themes/default/rc.lua 
 - Added bottom wibox
 - Added SSH prompt
 - Added OS command prompt
 - Added many widget at the bottom wibox
 - Added Vicious module (you need to get it...) [https://github.com/Mic92/vicious]
 - Actions menu entry
 - XRandR Auto mode
 - Probably More...
 
====

**How-to**

 1. Copy the content of themes/default/ in /usr/share/awesome/themes/default/
 2. Copy the content of icons/ in /usr/share/awesome/icons
 3. Copy the content of config/ in $HOME/.config/awesome --> If .config/awesome doesn't exists create it: mkdir -p $HOME/.config/awesome, then copy rc.lua from this repo to $HOME/.config/awesome
 4. Try to run Awesome :)

====

**[FIXED:theme.lua] ISSUE: Invalid title when minimize**
**[FIXED:WARN] Screenshot @ awesome reload/startup**
**[WARN:TERMINAL] Keybinding crash, needs configuration reload**

