# My Polybar Config

 ![screenshot](polybar_ss_zoomed.png)
 This is my polybar setup runnning on Linux Mint. 

[Polybar](https://github.com/polybar/polybar) lets you create customizable task bars for linux desktop environments. It comes with many features to show details about widely used services. These include common features that you can probably see on your taskbar right now (start menu, applications, network, sound, clock, etc). More importantly, it gives people the power to create their very own modules using scripts for functionality.

These scripts are for custom polybar modules that are included in my setup. Basically, these add features to the taskbar that I find useful for how I use my desktop on a daily basis. For example, instead of just launching a new window on button click, I wanted to be able to click it again to either minimize it, or maximize it. As well as displaying window icons for applications that are minimized. 

## Custom Scripts
1) window_toggle.sh
   - Launches a new application, if none are running, minimizes, or maximizes the window. 
   - Used with: apps menu module.
3) minimized_windows.sh
   - Checks for all minimized windows and maps an icon to be displayed on bar.
   - Used with: minimized apps module.
  
## Tools Used
### Window Management
- xdotool
- wmctrl
- xprop

## Polybar Modules
- Search menu
- Workspaces
- Apps menu 
- Spotify player
- Minimized apps
- System tray
- Network
- Sound
- Settings
- Power menu
- Time
 
 ![screenshot](polybar_ss_setup_2.png)
 Integrated with [themes](https://github.com/adi1090x/polybar-themes) using [pywal](https://github.com/dylanaraps/pywal) for auto color generation based on current wallpaper. Pywal color is used for my terminal and IDE theme as well.

