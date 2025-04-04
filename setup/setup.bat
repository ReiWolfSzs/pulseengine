@echo off
title Pulse Engine Setup - Start
echo Welcome to the Pulse Engine Automatic Setup!
TIMEOUT 3 >nul

echo This will automatically install all of the needed libraries and dependencies for compiling.
echo This setup also expects that you already have Haxe 4.3.0, the open-source toolkit, installed and ready to use
echo And also expects you to have Git installed

echo So if you don't have those, feel free to go to the following wepages to install the software.
echo Haxe: https://haxe.org/download/
echo Git: https://git-scm.com/downloads/

TIMEOUT 4 >nul
pause
cls

title Pulse Engine Setup - Installing HaxeFlixel
echo It is time to install the engine that Funkin' uses - HaxeFlixel.

haxelib set hxCodec 2.6.1
haxelib set flixel 5.4.0
haxelib set flixel-addons 3.3.0
haxelib set flixel-ui 2.6.1
haxelib set hxcpp-debug-server 1.2.4
haxelib set lime 8.1.2
haxelib set openfl 9.3.3
haxelib set hxcpp 4.3.2

title Forever Engine Setup - Installing Additional Libraries
haxelib git discord_rpc https://github.com/Aidan63/linc_discord-rpc
cls

title Pulse Engine Setup - The End!
echo And this is where the setup comes to an end
TIMEOUT 2 >nul
echo That's all!
pause
