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
> !! - High Priority <br>
> ?? - Low Priority

* [ ] Add 10 Games (6/10) **[!!]**
* [ ] Controller Support **[!!]**
* [ ] Better In-Game Crash Handler
* [ ] Custom Music Loading (With JSON) **[??]**
* [X] Custom Language Loading (with TXT) (Might add mod support soon)

## Wanna build?
1. Install/Download the following:
    * [Git](https://git-scm.com/download)
    * [Haxe (4.3.3 or higher)](https://haxe.org/download/version/4.3.3/)
    * VS Community 2019 (Windows Only)
    * VS Code (Optional)

2. Install these 2 components for VS Community 2019:
    * MSVC v142 - VS 2019 C++ x64/x86 build tools
    * Windows SDK (10.0.17763.0)
        * You can skip this by running `msvc.bat`.
> [!NOTE]
> These will take up 4GB on your device!

3. Download the dependencies.
    * If your target platform is Windows, run `setup.bat`.
    * If your target platorm is Linux or Mac, run `setup.sh`.

4. Use `lime test <platform> -release` to build (Replace `<platform>` with your target (e.g., `windows`, `mac`, `linux`)).
    * If you want to compile as a debug, replace `-release` with `-debug`.