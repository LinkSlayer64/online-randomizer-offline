Set "w="
Set "h="
for /f "delims=" %%g in ('..\imagemagick\identify -format "%%w" %1') do set w=%%g
for /f "delims=" %%b in ('..\imagemagick\identify -format "%%h" %1') do set h=%%b
Set "o=0"
echo %w%
echo %h%
if %w% GTR 30 Set "o=1"
if %h% GTR 30 Set "o=1"
echo %o%
if %o% EQU 1 del %1
