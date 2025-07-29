# My Polybar Config

 ![screenshot](polybar_ss_zoomed.png)
 This is my polybar setup runnning on Linux Mint. 

[Polybar](https://github.com/polybar/polybar) lets you create customizable task bars for Linux desktop environments. It comes with many features to show details about widely used services. These include common features that you can probably see on your taskbar right now (start menu, applications, network, sound, clock, etc). It also makes it possible to create custom modules using scripts for functioinality.

## Custom Scripts
1) window_toggle.sh
   - Launches a new application window, minimizes, or maximizes the window.
   - Formats the application icon (background color, underline, etc) according to window status.
3) minimized_windows.sh
   - Displays all minimized windows. Click to restore a window.
  
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

