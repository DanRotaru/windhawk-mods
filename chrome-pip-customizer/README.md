# Chrome PiP Customizer

A [Windhawk](https://windhawk.net/) mod that customizes the video
picture-in-picture (PiP) window of Google Chrome.

By default the window gets a compact player: no dimming on hover, a
transparent play/pause button left of the progress bar, everything on one row,
a pin button instead of minimize, and click-to-pause on the video.

```
[▶] 2:50 / 10:27 ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ [⛶] [🔊]
```

## Features

| Setting | What it does |
| --- | --- |
| **Hover shading** | Remove the dark overlay that dims the whole video while the pointer is over the window (on by default), and the dark gradients behind the top bar and the bottom controls. |
| **Playback controls position** | Keep the 10 seconds back, play/pause and 10 seconds forward buttons in the center (Chrome default), move them to the bottom left, bottom center or bottom right (on the line of the time and the volume button), or put them left (default) or right of the progress bar. |
| **Put all controls on one row** | Puts the time (before the progress bar), volume and live caption buttons on the progress bar's row, at the bottom of the window (on by default). |
| **Play/pause button size** | 28 (default), 32 or 36 px when the controls aren't in the center. |
| **Play/pause button style** | Transparent with a light circle on hover like the close button (default), a subtle light circle, a dark circle, or Chrome's style. |
| **Show the full screen button** | A button left of the volume button that makes the window fill its screen, like double-clicking the video (on by default). |
| **Show the crop button** | A button in the top right, left of the pin button, that enlarges the video to fill the whole window, cutting off its edges, so there are no black bars; click again to show the whole video (on by default). |
| **Show the pin button** | A button in the top right, in place of minimize, that keeps the window above other windows (solid icon) or lets them cover it. Every PiP window opens pinned. |
| **Remove the size limits** | Resize the window below Chrome's 284×160 minimum and above its 80%-of-the-screen maximum (on by default). |
| **When closing** | One behavior for every way of closing the window (close button, Alt+F4, taskbar, middle click, Ctrl+click): go back to the tab (default), pause the video, or keep it playing. |
| **Site name** | Show or hide the site name and its icon in the top left corner, or show the tab title instead of the site name. |
| **Click the video to play/pause** | A click that doesn't move the window plays or pauses; dragging still moves it. |
| **Hide the border and rounded corners in full screen** | Removes the 1 px border and rounded corners Windows draws around the window while it is in full screen (off by default). |
| **Double-click for full screen** | The window fills its screen with only the video; double-click again or press Esc to restore it. A pinned window is unpinned while in full screen and pinned again afterwards. |
| **Middle click or Ctrl+click closes the window** | Uses the "When closing" behavior. |
| **Hide controls** | Hide the minimize (hidden by default), back to tab, close, volume, live caption (hidden by default), play/pause, 10 seconds back/forward (both hidden by default) and previous/next track buttons, the progress bar and the time. |

The remaining top buttons move together when one of them is hidden, the
volume button moves into the live caption button's place when that is hidden,
and the progress bar uses the full width when the previous/next track buttons
are hidden. When the time, volume and live caption buttons are all hidden, the
progress bar's row moves down onto the bottom line. A hidden control no longer
takes clicks, so the window can be dragged from where it was.

## Notes

- Settings apply the next time the pointer moves over an open PiP window.
- After turning off the pin button, or disabling the mod, reopen the PiP
  window to get Chrome's minimize button and layout back.
- Only Chrome's own video PiP window is changed. Document PiP windows that
  websites build themselves are web pages and are not affected.
- The mod hooks `chrome.dll` by its debug symbols. The first start on a new
  Chrome version downloads Chrome's symbol file (several GB), which can take a
  while; later starts use Windhawk's cache.
- Tested with Chrome 158 on Windows 11.

## How it works

Chrome lays out the PiP controls in
`VideoOverlayWindowViews::OnUpdateControlsBounds()`. The mod runs right after
it and moves, resizes or hides the child views. It finds them in the window
object by their class (each is checked against its class's vtable), so a
Chrome update that changes the window's layout disables the mod instead of
touching the wrong views.

Chrome reports the video area to Windows as the window's caption, which is
what makes it draggable. The mod subclasses the PiP window and treats a
caption press that ends without moving the window as a click. A double-click
undoes the play/pause of its first click before toggling full screen, as video
sites do. The pin button is Chrome's minimize button with a pin icon; the mod
takes its clicks before Chrome sees them.
