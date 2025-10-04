@echo off
:: Исходная папка
set "SOURCE=C:\Users\user\Desktop\tempPhotosCropped"

:: Папка назначения
set "DEST=C:\Users\user\Desktop\tempPhotosCompressed"

:: Создать папку назначения, если её нет
if not exist "%DEST%" mkdir "%DEST%"

:: Цикл по всем PNG-файлам в исходной папке
for %%F in ("%SOURCE%\*.png") do (
    echo Обработка файла %%~nxF...

    :: Шаг 1. Конвертация в RGB + 1-битный альфа
    magick "%%F" ^
        -alpha on ^
        -channel A -depth 1 ^
        -colors 128 -type PaletteAlpha ^
        -depth 8 ^
        -define png:compression-level=9 ^
        -strip "%DEST%\%%~nxF"

    
)
::optipng -o7 -strip all "%DEST%\% %~nxF" "% %F"
echo.
echo Готово!
pause
