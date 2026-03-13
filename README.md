[English](README.md) | [Français](README.fr.md) | [Русский](README.ru.md) | [简体中文](README.zh_cn.md)

# Addon Manager
Allows addons to be toggled and gives access to their settings (if supported).
Double click the title bar to pin the window to the top UI layer.

![Addon Manager](https://i.imgur.com/C4DWrRA.png)

**WARNING: Reloading can crash the client**

Addon reloads are generally safe but **can cause crashes** in certain circumstances:
- Infinite loops
- UI memory leaks or texture loading issues
- Conflicts with other addons or existing UI objects


## Developers
The settings button next to each addon fires the `UI_ADDON` event for the addon.