@echo off
chcp 65001 >nul
setlocal EnableDelayedExpansion

echo.
echo ============================================
echo    zalo-tg Setup -- XIU Fleet Platform
echo ============================================
echo.

set "ENV_FILE=%~dp0.env"

rem -- Doc gia tri cu neu .env da ton tai
set "OLD_TG_TOKEN="
set "OLD_TG_GROUP_ID="
set "OLD_DATA_DIR=./data"
set "OLD_WEBHOOK_PORT=3001"
set "OLD_WEBHOOK_SECRET="

if exist "%ENV_FILE%" (
    echo [*] Phat hien file .env cu -- gia tri hien tai se dung lam mac dinh.
    echo.
    for /f "usebackq tokens=1,* delims==" %%A in ("%ENV_FILE%") do (
        set "key=%%A"
        set "val=%%B"
        if "!key!"=="TG_TOKEN"        set "OLD_TG_TOKEN=!val!"
        if "!key!"=="TG_GROUP_ID"     set "OLD_TG_GROUP_ID=!val!"
        if "!key!"=="DATA_DIR"        set "OLD_DATA_DIR=!val!"
        if "!key!"=="WEBHOOK_PORT"    set "OLD_WEBHOOK_PORT=!val!"
        if "!key!"=="WEBHOOK_SECRET"  set "OLD_WEBHOOK_SECRET=!val!"
    )
)

rem -- TG_TOKEN
echo --- Telegram Bot ---
echo.
echo [ TG_TOKEN ]
echo   Bot token lay tu @BotFather tren Telegram
echo   Dang: 123456789:AAxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
if not "!OLD_TG_TOKEN!"=="" (
    echo   Mac dinh: !OLD_TG_TOKEN!
)
set /p "TG_TOKEN=  > "
if "!TG_TOKEN!"=="" (
    if "!OLD_TG_TOKEN!"=="" (
        echo [!] TG_TOKEN la bat buoc!
        pause
        exit /b 1
    )
    set "TG_TOKEN=!OLD_TG_TOKEN!"
)

echo.

rem -- TG_GROUP_ID
echo [ TG_GROUP_ID ]
echo   ID cua Telegram supergroup (so am)
echo   Cach lay: them @userinfobot vao group, no se gui ID
echo   Dang: -1001234567890
if not "!OLD_TG_GROUP_ID!"=="" (
    echo   Mac dinh: !OLD_TG_GROUP_ID!
)
set /p "TG_GROUP_ID=  > "
if "!TG_GROUP_ID!"=="" (
    if "!OLD_TG_GROUP_ID!"=="" (
        echo [!] TG_GROUP_ID la bat buoc!
        pause
        exit /b 1
    )
    set "TG_GROUP_ID=!OLD_TG_GROUP_ID!"
)

echo.

rem -- DATA_DIR
echo --- Data and Storage ---
echo.
echo [ DATA_DIR ]
echo   Thu muc luu credentials.json va topics.json
echo   Mac dinh: !OLD_DATA_DIR!
set /p "DATA_DIR=  > "
if "!DATA_DIR!"=="" set "DATA_DIR=!OLD_DATA_DIR!"

echo.

rem -- WEBHOOK_PORT
echo --- Webhook Server ---
echo.
echo [ WEBHOOK_PORT ]
echo   Port de XIU backend gui thong bao vao Zalo
echo   Mac dinh: !OLD_WEBHOOK_PORT!
set /p "WEBHOOK_PORT=  > "
if "!WEBHOOK_PORT!"=="" set "WEBHOOK_PORT=!OLD_WEBHOOK_PORT!"

echo.

rem -- WEBHOOK_SECRET (tuy chon)
echo --- Bao mat (tuy chon) ---
echo.
echo [ WEBHOOK_SECRET ]
echo   Bearer token de bao mat webhook (co the bo trong)
if not "!OLD_WEBHOOK_SECRET!"=="" (
    echo   Mac dinh: !OLD_WEBHOOK_SECRET!
)
echo   Neu co, XIU backend phai gui: Authorization: Bearer ^<secret^>
set /p "WEBHOOK_SECRET=  > "
if "!WEBHOOK_SECRET!"=="" set "WEBHOOK_SECRET=!OLD_WEBHOOK_SECRET!"

echo.

rem -- Ghi file .env
echo [*] Dang ghi file .env ...

(
    echo # Telegram Bot token tu @BotFather
    echo TG_TOKEN=!TG_TOKEN!
    echo.
    echo # Telegram supergroup ID ^(so am, vd: -1001234567890^)
    echo TG_GROUP_ID=!TG_GROUP_ID!
    echo.
    echo # Thu muc luu credentials.json va topics.json
    echo DATA_DIR=!DATA_DIR!
    echo.
    echo # Port webhook cho XIU backend
    echo WEBHOOK_PORT=!WEBHOOK_PORT!
) > "%ENV_FILE%"

if not "!WEBHOOK_SECRET!"=="" (
    echo. >> "%ENV_FILE%"
    echo # Bearer token bao mat webhook ^(tuy chon^) >> "%ENV_FILE%"
    echo WEBHOOK_SECRET=!WEBHOOK_SECRET! >> "%ENV_FILE%"
)

echo [OK] Da tao file .env
echo.

rem -- npm install
set /p "DO_INSTALL=Chay 'npm install' ngay bay gio? [Y/n] > "
if /i "!DO_INSTALL!"=="n" goto skip_install
    echo.
    echo [*] Dang chay npm install ...
    call npm install
    echo [OK] Da cai dat xong dependencies
:skip_install

rem -- Summary
echo.
echo ============================================
echo    Setup hoan tat!
echo ============================================
echo.
echo Cac buoc tiep theo:
echo   1. Chay bot:    npm run dev
echo   2. Login Zalo:  Gui /login trong Telegram group
echo   3. Quet QR:     Mo Zalo tren dien thoai va quet QR
echo.
echo Sau khi login xong, zalo-tg san sang nhan thong bao tu XIU.
echo.
pause
