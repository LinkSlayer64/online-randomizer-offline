

rmdir /S /Q sprites 
rmdir /S /Q backsprites 
rmdir /S /Q backsprites_ 

mkdir sprites

wget -O sprites.png http://wyndows.sweb.cz/Pokemon%%20Sprites%%20in%%20Gen%%201%%20Style%%20fixed.png
wget -O backsprites.png "http://wyndows.sweb.cz/Gen%%201%%20Backsprites.png"



.\imagemagick\convert sprites.png -crop 96x96 +repage -scene 1 +adjoin sprites/%%03d.png
.\imagemagick\mogrify -trim -flop -background white -gravity center -extent 56x56 -dither None -colors 4 sprites\*

REM convert xymons.png -crop 59x59 +repage +adjoin -crop 56x56+1+1 -scene 650 -colors 4 sprites/%03d.png

REM mkdir backsprites
xcopy /S /Y .\sprites\ .\backsprites\

.\imagemagick\mogrify -trim -flop +repage -background white -gravity northeast -crop 32x32-4+0! -flatten backsprites\*
.\imagemagick\mogrify -dither None -colors 4 backsprites\*

mkdir backsprites_
.\imagemagick\convert backsprites.png -crop 96x96 +repage -scene 1 +adjoin backsprites_\%%03d.png
.\imagemagick\mogrify -trim backsprites_\*

REM do lots of identifies and delete non-backsprites


forfiles /P .\backsprites_ /C "cmd /c %cd%\imagecheck.bat @file @path"











.\imagemagick\mogrify -trim +repage -background white -gravity south -crop 28x28+0+0! -gravity northwest -crop 32x32-0-0! -flatten backsprites_\*
.\imagemagick\mogrify -dither None -colors 4 backsprites_\*

robocopy /XC /XN /XO /S .\backsprites\ .\backsprites_\
PAUSE
python gfx.py 2bpp sprites/* backsprites/* backsprites_/*
python pic.py compress sprites/*.2bpp backsprites/*.2bpp backsprites_/*.2bpp
python rbypals.py

PAUSE