# HEXCODE
#### Video Demo: https://youtu.be/ZEKs4p--FZ4
#### Description: 
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
## Description of each file in the project
#### 📁 Sources/  
- #### 📁 hexcode/
  - #### 📁 Controllers/
    - ##### ArgumentValidator+Error.swift
      Error enum that contains possible errors that can be thrown by `ArgumentValidator` during input argument validation.
    - ##### ArgumentValidator.swift
      A class that validates input argument string by checking if it a valid hexadecimal color code. If the argument is invalid, it will throw errors describing the reason.
    - ##### AssetCollector.swif
      The class in this file is an object that uses `FileManager` to perform recursive search at a given path, find valid Xcode color sets and translate them as code representation. This file also contains an `AssetCollecting` protocol, which I introduced to make it replaceable with a mock for testing purposes.
    - ##### ColorFinder.swift
      This file contains a `ColorFinder` controller which takes an array of named color sets that were collected by `AssetCollector` and a hexadecimal color code string that has been previously validated by `ArgumentValidator`, and tries checks if any of the color sets have matching color value. If one or more colors found, their names are returned together in an array. It also checks for light/dark mode appearance variants of a color, in case those were set - and adds that description to a color name. Also, there is a `ColorFinding` protocol in this file, which `ColorFinder` conforms to, and which is used to decouple it from the `HexcodeApp` and make it testable.
  - #### 📁 Models/
    - ##### ColorAsset+Color+ColorSpace.swift
      This file contains an enum that represents what is displayed as "Content" in Xcode Attribute Inspector panel, but actually is a "color-space" attribute in the color's JSON. It only includes options for the colors that can be currently supported by the app. For example, gray scale colors aren't supported yet, so I haven't included those on purpose (such color won't decode as a valid color). Also, the values for different colors might need translation between color spaces, but that's for the future iterations of the app. Right now, the app will work best with srgb color space.
    - ##### ColorAsset+Color+Components.swift
      Struct representing an object with actual RGBA components from inside of color json.
    - ##### ColorAsset+Color.swift
      In this file I stored the representation of the actual color object (part of the JSON that encapsulates color components, idiom etc. for a color variation). This struct also contains an `rgbHex` computed property, which I implemented as a place where convertion happens from color components into a hexadecimal value. Private methods, formatter instance and private component type enum that are used for this convertion are also stored in this file. It seemed an easy way to make this part of code usable and testable, but I might move the convertion logic to one of the controllers in the future to keep the model as lightweitht as possible.
    - ##### ColorAsset.swift
      A struct which is a decodable representation of one of the objects in the `"colors"` array from a color set's `Contents.json` file. There are also `Idiom` and `Appearance` in stored this file, which represent objects that `ColorAsset` json object consists of. I added these because the color sets can have multiple color assets in the `colors` array of a single color set (which has a single name), that have different color values because Xcode allows setting different color variations for different appearances ("Dark" vs. "Light"), devices ("iPhone", "mac", "watch" etc.).
    - ##### ColorSet.swift
      Struct that can be decoded from `Contents.json` in a `*.colorset` folder. At least for now it only contains part of the properties that have just enough necessary information about the colors to make the search possible and to determine a few basic supported color setting variations.
    - ##### NamedColorSet.swift
      This is a struct object that ties a Swift decoded representation of `Contents.json` in a "*.colorset" directory of color asset to the name of this asset. This way an array of such object can be searched for the matching color and get the associated color set name.
    - ##### PathContentType.swift
      The eponymous enum in this file has 3 cases that define 3 possible types of content which `FileManager` can encounter at any given path: a directory with `.colorset` ending, any other directory, or a file.
  - ##### Hexcode.swift
    Entry point for the `hexcode` command. It is a struct that implements Swift Argument Parser's `ParsableCommand` protocol, which simplifies work with command line arguments and options, and provides some default behaviour that's usually expected from a CLI app, like help and descriptions.
  - ##### HexcodeApp.swift
    A class that encapsulates the app's logic, connects and launches all the necessary parts. It was split away from the main `Hexcode` command file to make the app more configurable and testable.
<details>
<summary>

#### 📁 Tests/
</summary>

  - #### 📁 hexcodeTests/
    - #### 📁 Helpers/
      - ##### XCTestCase+makeResourcePath.swift
        This file contains an extension to `XCTestCase` with a helper method that helps find the path to where resources are stored. This was necessary because when tests run from command line vs. when they are just launched from Xcode, that path is different.
    - #### 📁 Mocks/
      - ##### AssetCollectorMock.swift
        A mock class that can be used as a substitute for `AssetCollector` dependency. The results are used to provide controlled output for methods and getters, and calls enum - allows checking the fact that those were called, and had specific parameters passed into them.
      - ##### ColorFinderMock.swift
        The mock stored here is substituting `ColorFinder` and follows the same mock structure with logged calls and configurable call results.
      - ##### FileManagerMock.swift
        A subclass of the `FileManager` from Foundation, with its methods and properties used in this app overriden to make it into a mock. It means they don't actually do anything with real files but simulate the possible outputs of a `FileManager`, which can be controlled through the mock's `results`. And the information about calling them is stored as `calls`. Also, there is an additional `PathContent` enum, which is used just to make it easier to set the desired results by setting the type of content in `fileExistsAtPath` dictionary.
    - #### 📁 Resources/
      - #### 📁 Assets.xcassets/
        - #### 📁 blackColorHex.colorset/
          - ##### Contents.json
            Xcode auto-generated color content file, for a valid black color asset, used for testing purposes. 
        - #### 📁 cyan.colorset/
          - ##### Contents.json
            Xcode auto-generated color content file, for a valid cyan color asset with int components, used for testing purposes. 
        - #### 📁 cyanColorHex.colorset/
          - ##### Contents.json
            Xcode auto-generated color content file, for a valid cyan color asset, used for testing purposes. 
        - #### 📁 cyanWithMixedComponentTypes.colorset/
          - ##### Contents.json
            Xcode auto-generated color content file, for cyan color asset that has each component written in different type (int, float and hex),  used for testing purposes. 
        - #### 📁 defaultTextHex.colorset/
          - ##### Contents.json
            Xcode auto-generated color content file, for a valid color asset of default text color, used for testing purposes. 
        - #### 📁 denimFloat.colorset/
          - ##### Contents.json
            Xcode auto-generated color content file, for a valid denim-blue color asset with float components, used for testing purposes. 
        - #### 📁 hexcode_logo.imageset/
          - ##### Contents.json
            Xcode auto-generated file describing the contents of the hexcode logo image set.
          - ##### `hexcode_logo@1x`.png
            Logo image for the hexcode app in 1x resolution, used in this README and also server as "noise" file for the tests to run in a more realistic environment. 
          - ##### `hexcode_logo@2x`.png
            Logo image for the hexcode app in 2x resolution, used in this README and also server as "noise" file for the tests to run in a more realistic environment. 
          - ##### `hexcode_logo@3x`.png
            Logo image for the hexcode app in 3x resolution, used in this README and also server as "noise" file for the tests to run in a more realistic environment. 
        - #### 📁 orange.colorset/
          - ##### Contents.json
            Xcode auto-generated color content file, for a valid orange color asset with int components, used for testing purposes. 
        - #### 📁 sunflowerHex.colorset/
          - ##### Contents.json
            Xcode auto-generated color content file, for a valid sunflower yellow color asset with int components, used for testing purposes. 
        - #### 📁 whiteColorHex.colorset/
          - ##### Contents.json
            Xcode auto-generated color content file, for a valid white color asset, used for testing purposes. 
        - ##### Contents.json
      - #### 📁 AssetsInSubdirectories.xcassets/
        - #### 📁 OtherColors/
          - #### 📁 greenColorHex.colorset/
            - ##### Contents.json
              Xcode auto-generated color content file, for a valid green color asset, used for testing purposes.
          - #### 📁 more_colors/
            - #### 📁 blueColorHex.colorset/
              - ##### Contents.json
                Xcode auto-generated color content file, for a valid blue color asset, used for testing purposes.
            - ##### Contents.json
              Xcode auto-generated tracking file for asset directories.
          - ##### Contents.json
            Xcode auto-generated tracking file for asset directories.
        - #### 📁 redColorHex.colorset/
          - ##### Contents.json
            Xcode auto-generated color content file, for a valid red color asset, used for testing purposes.
        - ##### Contents.json
          Xcode auto-generated tracking file for asset directories.
      - #### 📁 FakeContentFolder/
        - #### 📁 brokenColor.colorset/
          - ##### Contents.json
            Contents JSON file with correct name but without the necessary properties. Used for testing against false positives. For now such files are ignored by the app.
        - #### 📁 notAColor.colorset/
          - ##### text.txt
            A file that is not a JSON. Even though it is within a `*.colorset` folder, it should not be recognized as a color set file.
        - ##### Contents.json
          A valid JSON with the same name as the files inside each color set, but without the necessary properties. Used to test against false positives.
      - ##### EmptyFile
        As the name says, it's just an empty file. Used to test `AssetCollector` and the app for false positives.
    - #### 📁 Stubs/
      - ##### ColorSet+Stubs.swift
        This file contains instances of `ColorSet` and of its underlying parts. They're separated away from the tests themselves for the sake of readability.
      - ##### ColorSetJSON.swift
        The `ColorSetJSON` enum in this file serves the purpose of grouping JSON string stubs for a few different color sets. They are used to simulate decoding color set objects from JSON data.
      - ##### NamedColorSet+Stubs.swift
        The stubs for `NamedColorSet` contained here serve the same purpose, to provide the tests with instances of models that the logic can be tested on.
    - ##### ArgumentValidatorTests.swift
      Unit tests for the `ArgumentValidator`'s validation method.
    - ##### AssetCollectorTests.swift
      Unit tests for the `AssetCollector` class. It does not need to actually collects assets from the file system because the `FileManager` dependency is mocked and just sends the content it pretends to have found.
    - ##### ColorFinderTests.swift
      Unit tests for the `ColorFinder` class. They check if it can find a color from the code with and without the `#` symbol prefix, if it can detect different appearances etc.
    - ##### ColorSetTests.swift
      Unit tests for the `ColorSet` struct, or to be more specific, its decoding from JSON.
    - ##### ColorTests.swift
      Unit tests for the `Color` model. They basically are just the tests for the conversion logic from color components into a hexadecimal rgb string.
    - ##### HexcodeAppTests.swift
      Unit tests for the `HexcodeApp` entry point object for the app logic. They mainly check the results of the app `run` with different input and call results from dependencies, which are mocked.
    - ##### hexcodeEndToEndTests.swift
      End-to-end tests for the `hexcode` app. Unlike unit tests, these run the actual app executable on the actual files in the file system, using real dependencies, not mocks. This helps ensure all the real components integrate correctly with each other and the logic still works as intended.
</details>

##### Package.swift
Manifest for Swift Package Manager, that describes project structure.
##### Package.resolved
Dependency lock file, auto-generated by Swift Package Manager
##### .gitignore
Git file that tells git what to exclude from source control.
##### LICENSE
Standard MIT license file
##### README.md
This README file, which describes the `hexcode` project.
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
