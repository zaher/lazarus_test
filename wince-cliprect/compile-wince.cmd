@echo off
fpc Clipbox.lpr @extrafpc.cfg -oClipbox.exe -Parm -Twince -XParm-wince- -dLCL -dLCLwince -B
cecopy /s Clipbox.exe "dev:\Storage Card\Work"
pause

