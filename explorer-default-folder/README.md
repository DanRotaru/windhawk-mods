# Explorer Default Folder

Open new **File Explorer windows and tabs** in a folder of your choice instead
of **This PC**, **Home** or **Quick access**, or reopen the folder you closed
last.

Designed for 64‑bit File Explorer on Windows 10 and 11.

## Features

- **Your own start folder** — new windows and tabs open in any folder instead of
  This PC, Home (Windows 11) or Quick access (Windows 10).
- **Flexible paths** — normal paths (`D:\Documents`), environment variables
  (`%USERPROFILE%\Downloads`), paths relative to your user folder
  (`~\Downloads` or just `Downloads`) and shell locations (`shell:Downloads`).
- **Windows, tabs or both** — choose whether the folder is used for new windows,
  new tabs (Ctrl+T) or both.
- **Reopen last closed folder** — optionally open the folder of the most
  recently closed Explorer window or tab instead. It is remembered across
  Explorer restarts.
- **Leaves explicit folders alone** — opening Explorer for a specific folder,
  and navigating to This PC or Home yourself in an existing tab, works as
  usual.
- **Never blocks Explorer** — the mod's background thread doesn't hold up
  Explorer's windows, even when a folder is on a slow or offline network share.
- **No polling, no lag** — the mod reacts to Shell window events, so it costs
  nothing while idle.

## Settings

| Setting | Default | Description |
| --- | --- | --- |
| **Default folder** | *(empty)* | Folder opened in new windows and tabs. Leave empty to keep Explorer's default behavior. |
| **Apply to** | Both (new window and new tab) | Which new Explorer instances are redirected: both, new windows only, or new tabs only. |
| **Reopen last closed folder (ignores Default folder)** | Off | Open the most recently closed folder instead of the Default folder. The Default folder is only used until a folder has been closed, or if the last closed folder no longer exists. |

A Default folder which doesn't exist is ignored, and the new window or tab
stays where it opened.

## How it works

The mod uses documented Shell COM interfaces instead of Explorer's internal
functions, so it doesn't need an update for each Explorer build.

1. A background thread subscribes to the `ShellWindows` events, which fire
   whenever an Explorer window or tab opens or closes.
2. For each new tab it subscribes to the tab's navigation events and reads its
   first location. If that is This PC, Home or Quick access, the tab is
   navigated to your folder; any other location means Explorer was opened for
   a specific folder, and the tab is left alone.
3. A tab counts as a **new tab** when its top‑level window already has another
   tab, and as a **new window** otherwise.
4. To support **Reopen last closed folder**, the mod remembers the last real
   folder shown in each tab (start pages excluded). When tabs close, the one
   used most recently becomes the last closed folder and is saved with the
   mod's storage.
5. With an empty
   Default folder and **Reopen last closed folder** off, it doesn't subscribe
   to anything.

### Notes

- The new window or tab can show This PC or Home very briefly before it
  switches to your folder, and **Back** returns to This PC or Home.
- The mod can't tell a default launch from one explicitly opened at This PC or
  Home (for example the This PC desktop icon or `explorer shell:MyComputerFolder`);
  those are redirected too.
- With **Launch folder windows in a separate process** enabled, each Explorer
  process handles its own windows; the last closed folder is shared between
  them.
