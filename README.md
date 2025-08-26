# My Polybar Config
[Polybar](https://github.com/polybar/polybar) lets you create customizable task bars for Linux desktop environments. It comes with many features to show details about widely used services. These include common features that you can probably see on your taskbar right now (start menu, applications, network, sound, clock, etc). It also makes it possible to create custom modules using scripts for functionality.

## My Custom Scripts
1) toggle_app.sh
   - Launches a new application window, minimizes, or maximizes the window.
   - Formats the application icon (background color, underline, etc) according to window status.
3) minimized_windows.sh
   - Displays all minimized windows. Click to restore a window.
  
## Tools Used
### Window Management
- xdotool
- wmctrl
- xprop

## Dependencies
Install [polybar themes](https://github.com/adi1090x/polybar-themes) before trying to use these scripts. 

## Setup
### toggle_app.sh
- Add script into scripts folder.
- Add the following into your polybar config file.
```
[module/app]
type = custom/script
tail = true
interval = 1 
exec = ~/.config/polybar/docky/scripts/toggle_app.sh "<application_name>" 
click-left = ~/.config/polybar/docky/scripts/toggle_app.sh "<application_name>" toggle
```
- Depending on what application you want to launch, replace "<application_name>" with your desired application name in exec and click-left variables.
- Make sure to edit the get_icon() function in the script to assign font icons to application names ([Font Awesome](https://fontawesome.com/v4/icons/) or [Nerd Fonts](https://www.nerdfonts.com/)).

### minimized_windows.sh
- Add script into scripts folder.
- Add the following into your polybar config file.
```
[module/minimized]
type = custom/script
interval = 1
format-padding = 0
exec = ~/.config/polybar/docky/scripts/minimized_windows.sh
click-left = ~/.config/polybar/docky/scripts/minimized_windows.sh "restore"
```
- Again, make sure to edit the get_icon() function and assign the proper font icons to each app you want to use. Otherwise, a default icon will be displayed. 

## Customization
- You can use the pre-defined functions (under POLYBAR STYLING FUNCTIONS) in the script to customize module icon appearance according to window status. In my setup, I use a foreground + overline styling to signify when the window is active and a foreground styling to signify when the window is minimized.  

![screenshot](toggle_app_ss.png)

Using [polybar themes](https://github.com/adi1090x/polybar-themes) with [pywal](https://github.com/dylanaraps/pywal) you can choose to use the same color pallette for terminal, code editor, firefox, etc. 
