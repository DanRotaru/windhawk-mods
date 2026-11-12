# Windhawk Mods by DanRotaru

A collection of my [Windhawk](https://windhawk.net/) mods for Windows.

Windhawk is a customization marketplace for Windows that lets small native
mods hook into running programs. Each folder in this repository contains one
mod: a single `*.wh.cpp` source file plus its own README.

## Mods

| Mod | Description | Target |
| --- | --- | --- |
| [Chrome Context Menu Items](chrome-context-menu-items/) | Hides, adds, groups and reorders Google Chrome's context menu items, restyles Chrome's menus, and tweaks tabs and extension buttons. | `chrome.exe` |
| [Explorer Command Bar](explorer-command-bar/) | Adds custom action buttons and dropdown menus to the Windows 11 File Explorer command bar, and lets you hide the built-in buttons, separators and spacing. | `explorer.exe`, Windows 11 24H2 / 25H2 |

## Installing a mod

1. Install [Windhawk](https://windhawk.net/).
2. Open Windhawk and click **Create a new mod**.
3. Replace the template contents with the mod's `*.wh.cpp` file from this
   repository.
4. Click **Compile mod**, then adjust the options under **Settings**.

Mods published to the official Windhawk marketplace can instead be installed
directly from the Windhawk **Explore** tab.

## Development

Mods are single C++ files with a Windhawk metadata header (`==WindhawkMod==`)
that declares the target process, architecture, compiler options and settings
schema. They can be edited and compiled inside the Windhawk mod editor, or
built from this repository with the build scripts below.

## Building

[`build.bat`](build.bat) in the repository root compiles a mod with
Windhawk's own bundled compiler and deploys it to the installed Windhawk, the
same way **Compile Mod** in the editor does. Compiler errors are printed in
the terminal, and the running mod is reloaded right away. No toolchain other
than Windhawk is needed.

1. Set the Windhawk install folder in build.ini:

   ```
   [Windhawk]
   WindhawkPath=C:\Software\Windhawk
   ```

   This can be skipped if Windhawk is installed in `%ProgramFiles%\Windhawk`.
2. Build a mod:

   ```
   build.bat                          :: pick a mod from a menu
   build.bat start-menu-groups        :: build that mod directly
   build.bat start-menu-groups -CompileOnly
   build.bat start-menu-groups -Release
   ```

   Started without a mod name (for example by double-clicking it),
   `build.bat` lists the mods in the repository; choose one with the arrow
   keys and press Enter. Any `-Options` are passed on to the build.

Deploying needs admin rights, so each build shows a UAC prompt. To deploy
without prompts, run `build\build.ps1 -InstallDeployTask` once; it installs
an elevated scheduled task that does the deploy step.

See [`build/README.md`](build/README.md) for all options and a description
of how compiling and deploying works.

## Contributing

Bug reports and feature requests are welcome — please open an issue describing
your Windows version (e.g. 11 25H2) and the mod's settings you are using.

## License

[MIT](LICENSE) © Dan Rotaru <[dan13.me](https://dan13.me/)>
