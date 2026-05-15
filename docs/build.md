# How to build AutoScreenshot from sources

This program written with Pascal language in Lazarus IDE (similar to Delphi).

## Tools required

- Windows or Linux machine
- Lazarus IDE
- Free Pascal Compiler
- GIT
- Apache Ant
- Inno Setup

# Preparations

1) To download project sources clone repository using git. Don't forget to add `--recurse-submodules` flag!
   ```
   git clone git@github.com:artem78/AutoScreenshot.git --recurse-submodules
   ```
2) Download and install Apache Ant building tool
   
   Instructions: https://ant.apache.org/manual/install.html
   
3) Rename `local.properties.sample` to `local.properties`. Open `local.properties` as text file and change settings to yours.
4) Download and install Lazarus IDE + Free Pascal Compiler (FPC) - <https://www.lazarus-ide.org/index.php?page=downloads>. This software was written with old version 2.2.4 while latest Lazarus version for now is 4.6. I'm not sure if it can be succesfully built in modern versions and recommend to install [2.2.4](https://sourceforge.net/projects/lazarus/files/Lazarus%20Windows%2064%20bits/Lazarus%202.2.4/).
   - If you use Windows you should download and install lazarus-XXXXX-fpc-XXXXX-win64.exe and lazarus-XXXX-fpc-XXXXX-cross-i386-win32-win64.exe file (second one should be installed in the same dir where first)
   - For Linux install 3 packages (in this order) - fpc-src_XXXXX.deb, fpc-laz_XXXXXX.deb, lazarus-project_XXXXXX.deb
5) Install additional packages for Lazarus IDE
    * Start Lazarus and open online package manager
    
      ![](images/build/2026-04-08_20-42-27.png)
      
    * Find and install these packages one by one:
       * PlaySoundPackage / playwavepackage.lpk
       * BGRABitmap / bgrabitmappack.lpk
       * Uniqueinstance / uniqueinstance_package.lpk
    
      ![](images/build/2026-04-08_20-45-22.png)
      
      ![](images/build/2026-04-08_20-49-29.png)
      
      ![](images/build/2026-04-08_20-50-11.png)
      
      IDE will reboot after each package installation
<!--6) Download DLLs **(FOR WINDOWS ONLY)**
   
   Put [all required DLLs](dll_dependencies.md) (10 at the moment) to the project main directory. The easiest way to do this is to run this [Apache Ant](https://ant.apache.org/) command in project dir
   ```
   ant download_dlls
   ```
   Or just copy them from portable release zip.-->
   
## Manually build executable in Lazarus IDE

1) Start Lazarus IDE
2) Go to `Project` -> `Open project...` and select `AutoScreenshot.lpi` file in project sources dir
2) Choose `Debug` (or `Release`) build mode and press green arrow (or F9)
   ![](images/build/2026-04-08_21-04-31.png)
2) If the build completes successfully you should see working AutoScreenshot application

   ![](images/build/2026-04-27_17-54-03.png)
   
   Also in project root directory you should see file called `AutoScreenshot.exe` in Windows or `AutoScreenshot` in Linux.
   
   
## Make distributable zip (portable version)

32-bit:
```
ant -Darch=x86 zip
```

or/and 64-bit:
```
ant -Darch=x64 zip
```

## Make installer (Windows only)

Installer created with Inno Setup version 5.6.1 (u). You can download it [here](https://jrsoftware.org/isdl.php). Inno Setup project file called `setup.iss`. It makes one installer contains both 32 and 64 bit version of Auto Screenshot (so executable should be compiled twice for each cpu arhitecture).

Installer creation can be started with ant command
```
ant installer
```