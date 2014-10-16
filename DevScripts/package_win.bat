@echo Packaging for windows.
@set /p VERSION=<resources\version.txt

@if not exist "C:\Windows\System32\libfftw3-3.dll" (
	@echo "ERROR: C:\Windows\System32\libfftw3-3.dll (64-bit) not found."
	@goto end
)

@if not exist "C:\Windows\System32\lua51.dll" (
	@echo "ERROR: C:\Windows\System32\lua51.dll (64-bit) not found."
	@goto end
)

@if not exist "C:\Windows\SysWOW64\libfftw3-3.dll" (
	@echo "ERROR: C:\Windows\SysWOW64\libfftw3-3.dll (32-bit) not found."
	@goto end
)

@if not exist "C:\Windows\SysWOW64\lua51.dll" (
	@echo "ERROR: C:\Windows\SysWOW64\lua51.dll (32-bit) not found."
	@goto end
)

@if exist ..\Bin\packaged\protoplug-%VERSION%-win32.zip del ..\Bin\packaged\protoplug-%VERSION%-win32.zip
@if exist ..\Bin\packaged\protoplug-%VERSION%-win64.zip del ..\Bin\packaged\protoplug-%VERSION%-win64.zip

@echo Copying 32-bit libs for packaging...
@copy /Y C:\Windows\SysWOW64\libfftw3-3.dll ..\ProtoplugFiles\lib\
@copy /Y C:\Windows\SysWOW64\lua51.dll ..\ProtoplugFiles\lib\
@echo Creating 32-bit package...
@7z a ..\Bin\packaged\protoplug-%VERSION%-win32.zip "..\Bin\win32\Lua Protoplug Fx.dll" "..\Bin\win32\Lua Protoplug Gen.dll" ..\ProtoplugFiles

@echo Copying 64-bit libs for packaging...
@copy /Y C:\Windows\System32\libfftw3-3.dll ..\ProtoplugFiles\lib\
@copy /Y C:\Windows\System32\lua51.dll ..\ProtoplugFiles\lib\
@echo Creating 64-bit package...
@7z a ..\Bin\packaged\protoplug-%VERSION%-win64.zip "..\Bin\win64\Lua Protoplug Fx (x64).dll" "..\Bin\win64\Lua Protoplug Gen (x64).dll" ..\ProtoplugFiles

@echo Cleaning up...
@del ..\ProtoplugFiles\lib\libfftw3-3.dll
@del ..\ProtoplugFiles\lib\lua51.dll

@echo Packaging successful.
:end