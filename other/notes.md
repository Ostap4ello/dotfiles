# Some valuable info for my desktop

- remap keybaord keys / input with `input-remapper-bin` (aur)
- custom keyboard `./xkb/custom`, deployed to `/usr/share/X11/xkb/symbols/` (has some cool keys, see it), accessed by the name of the file
- nvidia modprobe options in `./nvidia-modprobe.conf`, deployed to `/etc/modprobe.d/`
- sddm themes in `./sddm-themes/`, deployed to `/usr/share/sddm/themes/`
    - `theme` and `theme-2` are the ones I made, minimalistic. -2 is newer
      iteration, with good tab completion, yet to be cleaned up and polished
    - `where_is_my_sddm...` is just cool theme worth mentioning
- udev rules in `./99-drive-mount.rules`, deployed to `/etc/udev/rules.d/`
    - 1st rule makes mount shared (into /media/), makes much more efficient /
      fast
    - 2nd rule does lazy unmounting of the selected drive when ejecting
      unexpectedly.
      Note: cannot use neither $devnode not UIID as the trigger happens after
      the drive is plugged out.
