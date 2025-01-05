  
  
<img src="Tests/hexcodeTests/Resources/Assets.xcassets/hexcode_logo.imageset/hexcode_logo@3x.png" width=25% align="center">  
A tool that finds Xcode color assets by their hex codes. The idea behind this tool is to speed up and ease the process of finding assets that were already added to the project. This helps prevent accidental duplication when there are too many color assets to go through and they are easy to miss because they have different component representations.

<p align="center">
    <br />
    <img alt-text="Swift Version" src="https://img.shields.io/badge/Swift-5.9-orange.svg">
    <a href="https://github.com/artem-y/hexcode/releases/latest"><img alt-text="GitHub Release" src="https://img.shields.io/github/v/release/artem-y/hexcode"></a>
    <img alt-text="Minimal macOS Version" src="https://img.shields.io/badge/macOS-13%2B-e08416">
</p>

### ⚠️Disclaimer:
For now, the tool only supports searching for exact values of color components as ints, floats or hexadecimals, without conversion between settings like content type (sRGB, Display P3, Gray Gamma 2.2 etc.), and ignoring some other settings like Gamut etc.  
## Usage
By default, the tool can be used from the terminal to search for matches to a given color code:
```
hexcode #ffa500
```
...where `#ffa500` is a hex color code, with or without `#`, case-insensitive.  

When used this way, `hexcode` will recursively search for the color assets matching the hex rgb value, starting from the current directory. The output will be one or more matching color set names, or a message in case it haven't found an asset with the given color. Color names include path to their color asset, relative to the project. The command also has some very simple error handling and might exit with error.  
More arguments and options will be added in the future with new features, they can be found using the `--help` flag.  
#### Default usage examples
Color found:  
<img width="568" alt="hexcode_usage_color_found_1" src="https://github.com/user-attachments/assets/5a25b195-c981-4048-8b4b-e17b8df10a25" />

Color not found:  
<img width="570" alt="hexcode_usage_no_such_color" src="https://github.com/artem-y/hexcode/assets/52959979/77a36d4c-9480-4603-9ae2-8a6bce410a4e">  

### Find Duplicates
Hexcode can also check a project or a directory for duplicated color assets.
```zsh
hexcode find-duplicates
```
Output example when there are duplicates:
```
#24658F MyProject/Assets.xcassets/AccentColor
#24658F MyProject/Colors.xcassets/defaultAccent
--
#999999 MyProject/Assets.xcassets/appColor/gray
#999999 MyProject/Colors.xcassets/neutralGray
```
Output when duplicates not found:
```
No duplicates found
```

## Installation
1. Clone the repository to your machine
2. Assuming the folder name "hexcode" has not changed, run in terminal:
```
cd hexcode
```
### Using Swift Package Manager:
Then run the following:
```
swift build -c release
mv .build/release/hexcode /usr/local/bin
```
(you might need `sudo` before the `mv` command, depending on your machine's configuration) 

3. Run `which hexcode` to make sure it is now visible  

Alternatively, it can be moved to some directory other than `/usr/local/bin`, just make sure that directory is included in `$PATH` if you want it visible from anywhere in terminal.  
Or you can just run it as an executable Swift package [without installation](#running-without-installation), using Swift Package Manager commands.
### Using make:
From the root of the repository, run the following command:
```
make install
```
With no in stallation path provided, it will try to install `hexcode` to where it's already installed. If this is the first-time installation, the default path is `/usr/local/bin`.  

There's also an option to provide a custom installation path:
```
make install </custom/installation/path>
```
Just make sure it's added to the PATH or sourced if you want the command to be visible from anywhere without typing the full path to it. Depending on the installation path and current user, `make install` command might need `sudo` access.
### Running without installation:
From the `hexcode` directory (or passing it as `--package-path`), the command can be run as executable package without previous installation, for example:
```
swift run hexcode e8de2a --directory=$HOME/Documents/myProject
```
## Testing
<p align="right">
<i>- "If it is not tested, I will send it back."<br>
- "If tests don't pass, I will send it back."</i>
</p>

Tests should work both from Xcode (Cmd+U after opening `Package.swift`) and Terminal:  
```
swift test
```
Core logic must be covered with tests that help decrease regression when developing new features, and also help understand how the app works.
