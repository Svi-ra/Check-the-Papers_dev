@echo off
:: Исходная папка
set "SOURCE=C:\Users\Nichita Sviridcenko\Desktop\Signatures_backup\s"

::set "SOURCE=C:\Users\user\Desktop\Signatures backup\h"

:: Папка назначения
set "DEST=C:\Users\Nichita Sviridcenko\Zomboid\Workshop\Check-the-Papers\Contents\mods\Check-the-Papers\42\media\textures\signatures\s"

::set "DEST=C:\Users\user\Zomboid\mods\Check The Papers\Check-the-Papers\Contents\mods\Check-the-Papers\42\media\textures\signatures\h"
:: Создать папку назначения, если её нет
if not exist "%DEST%" mkdir "%DEST%"

:: Цикл по всем PNG-файлам в исходной папке
for %%F in ("%SOURCE%\*.png") do (
    echo Обработка файла %%~nxF...

    :: Применяем ImageMagick и сохраняем в DEST
    magick "%%F" -colorspace Gray -define png:color-type=4 -strip "%DEST%\%%~nxF"
)

echo Готово!
pause
