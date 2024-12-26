@echo off

echo.
echo Air Gallet / Akuu Gallet (OLD "A" version) Trainer Mod by alamone.
echo This mod adds various functions to Air Gallet.  See readme.txt for more details.
echo.

if not exist "agallet-roms\u45" goto errorout

echo Generating Air Gallet patch...
echo.
swap-bytes agallet-roms\u45 u45-
Asm68k.exe /e rom_version=0 /p agallet_hack.asm, u45-swap.bin
swap-bytes u45-swap.bin agallet-roms-modded\u45
echo.
echo Complete.  Results in "agallet-roms-modded" folder.
goto ending

:errorout
echo Error: missing rom files.
echo.
echo Please copy "u45" into the "agallet-roms" folder.
echo This file can be found in the "agalleta" folder of "agallet.zip".

:ending
echo.
pause
