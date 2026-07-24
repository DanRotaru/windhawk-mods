# Windhawk Mods by DanRotaru

A collection of my [Windhawk](https://windhawk.net/) mods for Windows.

Windhawk is a customization marketplace for Windows that lets small native
mods hook into running programs. Each folder in this repository contains one
mod: a single `*.wh.cpp` source file plus its own README.

## Mods

| Mod | Description | Target |
| --- | --- | --- |
| [Explorer Command Bar](exporer-command-bar/) | Adds custom action buttons and dropdown menus to the Windows 11 File Explorer command bar, and lets you hide the built-in buttons, separators and spacing. | `explorer.exe`, Windows 11 24H2 / 25H2 |

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
schema. Windhawk compiles and injects them itself, so no separate build system
or toolchain setup is required — editing and compiling happens inside the
Windhawk mod editor.

## Contributing

Bug reports and feature requests are welcome — please open an issue describing
your Windows version (e.g. 11 25H2) and the mod's settings you are using.

## License

[MIT](LICENSE) © Dan Rotaru <[dan13.me](https://dan13.me/)>
