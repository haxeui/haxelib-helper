@echo off
cd build\hxwidgets
if %1 == debug (
	Main-debug.exe
    pause
) else (
	Main.exe
)
