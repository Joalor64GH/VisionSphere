# VisionSphere [![Build](https://github.com/Joalor64GH/VisionSphere/actions/workflows/main.yml/badge.svg)](https://github.com/Joalor64GH/VisionSphere/actions/workflows/main.yml)
![](https://img.shields.io/github/repo-size/Joalor64GH/VisionSphere)
![](https://img.shields.io/github/issues/Joalor64GH/VisionSphere)
![](https://img.shields.io/badge/balls-in_your_jaws-green)

A gaming console made in HaxeFlixel. Mostly based on Sega Dreamcast.

> [!IMPORTANT]
> Check out the progress of the project below! <br>
> ![](https://geps.dev/progress/75)

> [!WARNING]
> This project is currently in development, and stuff may be unstable or not work at the moment. <br>
> So if you want to help, issue reports and pull requests would be nice!

## To-Dos
> [!NOTE]
> **!!** - High Priority <br>
> **??** - Low Priority

* [ ] Add 10 Games (8/10) **[!!]**
* [ ] Rhythmo Remake **[??]**
* [X] Controller Support for Real [yay]
* [X] WebM Video Support [how did i do that]

## Wanna build?
> [!TIP]
> To compile as debug, replace `-release` with `-debug`.

### Windows
1. Install [Haxe (4.3.3 or higher)](https://haxe.org/download/version/4.3.3/) and [HaxeFlixel](https://haxeflixel.com/documentation/install-haxeflixel/).
2. Download and install Microsoft Visual Studio Community.
3. On the Visual Studio installation screen, go to "Individual Components" and select the following:
    * MSVC v143 VS 2022 C++ x64/x86 build tools
    * Windows 10/11 SDK
        * You can skip this by running `msvc.bat`
        * ⚠ These will take up 4-5GB of available space on your computer.
4. Download and install [Git](https://git-scm.com/download).
5. Download the dependencies by running `setup-windows.bat`.
6. Use `lime test windows -release` to build.

> [!CAUTION]
> Linux and Mac builds have not been tested! <br>
> So if something goes wrong, report it in the issues tab!

### Linux
1. Install [Haxe (4.3.3 or higher)](https://haxe.org/download/version/4.3.3/) and [HaxeFlixel](https://haxeflixel.com/documentation/install-haxeflixel/).
2. Install `g++`.
3. Download and Install [Git](https://git-scm.com/download).
4. Download the dependencies by running `setup-linux.sh`.
5. Use `lime test linux -release` to build.

### Mac
1. Install [Haxe (4.3.3 or higher)](https://haxe.org/download/version/4.3.3/) and [HaxeFlixel](https://haxeflixel.com/documentation/install-haxeflixel/).
2. Install `Xcode` to allow C++ building.
3. Download and Install [Git](https://git-scm.com/download).
4. Download the dependencies by running `setup-mac.sh`.
5. Use `lime test mac -release` to build.