del love.zip

del main.lua
ren "main [Obfuscated].lua" main.lua

7z.exe a love.zip "../_pic*"
7z.exe a love.zip "main.lua"
7z.exe a love.zip "../conf.lua"

mkdir build-distill

copy "C:\Program Files\LOVE\love.dll"     "build-distill/love.dll"
copy "C:\Program Files\LOVE\lua51.dll"    "build-distill/lua51.dll"
copy "C:\Program Files\LOVE\mpg123.dll"   "build-distill/mpg123.dll"
copy "C:\Program Files\LOVE\OpenAL32.dll" "build-distill/OpenAL32.dll"
copy "C:\Program Files\LOVE\SDL2.dll"     "build-distill/SDL2.dll"

copy /b "C:\Program Files\LOVE\love.exe"+love.zip "build-distill/PointNavigation.exe"

del love.zip
del main.lua

@pause
