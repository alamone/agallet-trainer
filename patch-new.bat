@echo off

echo.
echo Air Gallet / Akuu Gallet (NEW version) Trainer Mod by alamone.
echo This mod adds various functions to Air Gallet.  See readme.txt for more details.
echo.

if not exist "agallet-roms\bp962a.u45" goto errorout

echo Generating Air Gallet patch...
echo.
swap-bytes agallet-roms\bp962a.u45 bp962a-.u45
Asm68k.exe /e rom_version=1 /p agallet_hack.asm, bp962a-swap.u45
swap-bytes bp962a-swap.u45 agallet-roms-modded\bp962a.u45
echo.
echo Complete.  Results in "agallet-roms-modded" folder.
goto ending

:errorout
echo Error: missing rom files.
echo.
echo Please copy "bp962a.u45" into the "agallet-roms" folder.
echo This file can be found in "agallet.zip".

:ending
echo.
pause
