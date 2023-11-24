  
<img src="Tests/hexcodeTests/Resources/Assets.xcassets/hexcode_logo.imageset/hexcode_logo@3x.png" width=25% align="center">  
A tool that finds Xcode color assets by their hex codes. The idea behind this tool is to speed up and ease the process of finding assets that were already added to the project. This helps prevent accidental duplication when there are too many color assets to go through and they are easy to miss because they have different component representations.

### ⚠️Disclaimer:
For now, the tool only supports searching for exact values of color components as ints, floats or hexadecimals, without conversion between settings like content type (sRGB, Display P3, Gray Gamma 2.2 etc.), and ignoring some other settings like Gamut etc.  
## Usage
The tool can be used like this from terminal:
```
hexcode #ffa500
```
...where `#ffa500` is a hex color code, with or without `#`, case-insensitive.  

This way `hexcode` will recursively search for the color assets matching the hex rgb value, starting from current directory. The output will be one or more matching color set names, or a message notifying that it haven't found an asset with the given color. The command also has some very simple error handling and might exit with error.  
More arguments and options will be added in the future with new features, they can be found using the `--help` flag.  
#### Examples
Color found:  
<img width="570" alt="hexcode_usage_color_found" src="https://github.com/artem-y/hexcode/assets/52959979/708ea8d5-b38a-4c69-813b-a987a28d4242">  

Color not found:  
<img width="570" alt="hexcode_usage_no_such_color" src="https://github.com/artem-y/hexcode/assets/52959979/77a36d4c-9480-4603-9ae2-8a6bce410a4e">

## Installation
1. Clone the repository to your machine
2. Assuming the folder name "hexcode" has not changed, run in terminal:
```
cd hexcode
swift build -c release
mv .build/release/hexcode /usr/local/bin
```
(you might need `sudo` before the `mv` command, depending on your machine's configuration) 

3. Run `which hexcode` to make sure it is now visible  

Alternatively, it can be moved to some directory other than `/usr/local/bin`, just make sure that directory is included in `$PATH` if you want it visible from anywhere in terminal.  
Or you can just run it as an executable Swift package [without installation](#running-without-installation), using Swift Package Manager commands.
### Running without installation
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
