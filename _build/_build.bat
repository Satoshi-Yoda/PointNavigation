del love.zip

7z.exe a love.zip "..\*"

7z.exe d love.zip "_build*"
7z.exe d love.zip "*.git*"

mkdir build-simple

copy "C:\Program Files\LOVE\love.dll"     "build-simple/love.dll"
copy "C:\Program Files\LOVE\lua51.dll"    "build-simple/lua51.dll"
copy "C:\Program Files\LOVE\mpg123.dll"   "build-simple/mpg123.dll"
copy "C:\Program Files\LOVE\OpenAL32.dll" "build-simple/OpenAL32.dll"
copy "C:\Program Files\LOVE\SDL2.dll"     "build-simple/SDL2.dll"

copy /b "C:\Program Files\LOVE\love.exe"+love.zip "build-simple/PointNavigation.exe"

del love.zip

@pause
