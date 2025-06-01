# scored

A simple score keeping application for tabletop games

## Assets

Assets are not included in the repository and need to be added separately.

### Android

In Android studio go to `File > New > Image Asset` to start adding the icon.

- In foreground import foreground.svg as ic_launcher_foreground (default)
- In background import background.svg as ic_launcher_background (default)
- In options set icon format to webp
- Leave other options default

In Android studio go to `File > New > Vector Asset` to start add the monochrome variant
- In path import foreground-mono.svg as ic_launcher_foreground_mon
- Leave other options default

### IOS

- In Flutter assets icon folder add the following files
  - foreground-ios.png
  - background-ios.png
  - foreground-mono-ios.png
- Generate icons with `dart run flutter_launcher_icons`

- In Xcode go to `Assets.xcassets > LaunchImage` and add the following files for 1x, 2x, and 3x sizes:
  - launch_image_ios100.png
  - launch_image_ios200.png
  - launch_image_ios300.png

- In Xcode go to `Assets.xcassets > LaunchBackground` and add the following files for 1x, 2x, and 3x sizes:
  - splash_ios.png
