<!-- <p align="center"> -->
<img src="Tests/hexcodeTests/Resources/Assets.xcassets/hexcode_logo.imageset/hexcode_logo@3x.png" width=25% align="center">  
<!-- </p> -->
<!-- <p align="center"> -->
  Find Xcode color asset by its hex code
<!-- </p> -->

### ⚠️Disclaimer:
For now, the tool only supports search for color assets that are represented as hex or 0-255 RGB integer values. If an asset has floating point numbers for it's RGB components, such asset will not be found even if it matches.
## Installation
1. Clone the repository to your machine
2. Assuming the folder name "hexcode" has not changed, run in terminal:
```
cd hexcode
swift build -c release
mv .build/release/hexcode /usr/local/bin
```
3. Run `which hexcode` to make sure it is now visible  

Alternatively, it can be moved to some directory other than `/usr/local/bin`, just make sure that directory is included in `$PATH` if you want it visible from anywhere in terminal.  
Or you can just run it as an executable Swift package [without installation](#running-without-installation), using Swift Package Manager commands.
## Usage
The tool can be used like this from terminal:
```
hexcode #ffa500
```
...where `#ffa500` is a hex color code, with or without `#`, case-insensitive.  

This way `hexcode` will recursively search for the color assets matching the hex rgb value, starting from current directory. The output will be one or more matching color set names, or a message notifying that it haven't found an asset with the given color. The command also has some very simple error handling and might exit with error.  
More arguments and options will be added in the future with new features, they can be found using the `--help` flag.  
### Running without installation
From the `hexcode` directory (or passing it as `--package-path`), the command can be run as executable package without previous installation, for example:
```
swift run hexcode e8de2a
```

