# VisionSphere [![Build](https://github.com/Joalor64GH/VisionSphere/actions/workflows/main.yml/badge.svg)](https://github.com/Joalor64GH/VisionSphere/actions/workflows/main.yml)
![](https://img.shields.io/github/repo-size/Joalor64GH/VisionSphere)
![](https://img.shields.io/github/issues/Joalor64GH/VisionSphere)
![](https://img.shields.io/badge/balls-in_your_jaws-green)

A gaming console made in HaxeFlixel. Mostly based on Sega Dreamcast.

> [!WARNING]
> This project is currently in development, and stuff may be unstable or not work at the moment. <br>
> So if you want to help, issue reports and pull requests would be nice!

## To-Dos
> [!NOTE]
> **!!** - High Priority <br>
> **??** - Low Priority

* [ ] Add 10 Games (7/10) **[!!]**
* [ ] Better In-Game Crash Handler
* [X] Better Main Menu
* [X] Custom Music Loading (With JSON)
* [X] Custom Language Loading (with TXT)

## Wanna build?
1. Install/Download the following:
    * [Git](https://git-scm.com/download)
    * [Haxe (4.3.3 or higher)](https://haxe.org/download/version/4.3.3/)
    * [HaxeFlixel](https://haxeflixel.com/documentation/install-haxeflixel/)
    * VS Community 2019 (Windows Only)
        * MSVC v142 - VS 2019 C++ x64/x86 build tools
        * Windows SDK (10.0.17763.0)
            * Please note that these will take up 4GB on your device.
            * Also, You can skip this by running `msvc.bat`.
    * VS Code (Optional)

2. Download the dependencies.
    * If your target platform is Windows, run `setup.bat`.
    * If your target platorm is Linux or Mac, run `setup.sh`.

3. Use `lime test [platform] -release` to build. Replace `[platform]` with your target.
    * If you want to compile as a debug, replace `-release` with `-debug`.