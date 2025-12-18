@echo off
setlocal enabledelayedexpansion

title Renomeador de Arquivos .WAV
color 0A

echo ============================================
echo      RENOMEADOR DE ARQUIVOS .WAV
echo ============================================
echo.
echo Formato: nome + numero(00-19) + _kit + numero(001-099) + _16bit_mono.wav
echo Exemplo: cras19_kit037_16bit_mono.wav
echo.

REM Configurar nome base
set /p PREFIX="Digite o nome base (ex: cras): "
if "%PREFIX%"=="" set "PREFIX=cras"

REM Configurar kit inicial
set /p KIT_INPUT="Digite o numero inicial do kit (1-99): "
if "%KIT_INPUT%"=="" set "KIT_INPUT=1"
set /A KIT_NUM=%KIT_INPUT%
if %KIT_NUM% LSS 1 set KIT_NUM=1
if %KIT_NUM% GTR 99 set KIT_NUM=99

echo.
echo Configuracao: %PREFIX% com kit inicial %KIT_NUM%
echo.

REM Contar arquivos WAV
set COUNT=0
for %%f in (*.wav) do set /a COUNT+=1

if %COUNT%==0 (
    echo Nenhum arquivo .wav encontrado!
    pause
    exit
)

echo Encontrados %COUNT% arquivos .wav
echo.

REM Mostrar preview
echo PREVIEW DOS NOVOS NOMES:
echo -------------------------
set INDEX=0
set FILE_NUM=0
set CURRENT_KIT=%KIT_NUM%

for %%f in (*.wav) do (
    call :format_numbers
    
    echo %%f --^> %PREFIX%!FILE_NUM_STR!_kit!KIT_STR!_16bit_mono.wav
    
    set /a INDEX+=1
    set /a FILE_NUM+=1
    
    if !FILE_NUM! EQU 20 (
        set /a CURRENT_KIT+=1
        set FILE_NUM=0
    )
)

echo.
choice /C SN /M "Continuar com a renomeacao (S/N)?"
if errorlevel 2 (
    echo Cancelado.
    pause
    exit
)

echo.
echo Renomeando arquivos...
echo.

REM Criar log
set LOG=renomeacao_%date:~6,4%%date:~3,2%%date:~0,2%.log
echo Log da renomeacao > %LOG%
echo. >> %LOG%

set INDEX=0
set FILE_NUM=0
set CURRENT_KIT=%KIT_NUM%
set OK=0
set ERRO=0

for %%f in (*.wav) do (
    call :format_numbers
    
    set NEW_NAME=%PREFIX%!FILE_NUM_STR!_kit!KIT_STR!_16bit_mono.wav
    
    if not exist "!NEW_NAME!" (
        ren "%%f" "!NEW_NAME!"
        echo %%f --^> !NEW_NAME! >> %LOG%
        echo OK: %%f --^> !NEW_NAME!
        set /a OK+=1
    ) else (
        echo ERRO: !NEW_NAME! ja existe >> %LOG%
        echo ERRO: !NEW_NAME! ja existe
        set /a ERRO+=1
    )
    
    set /a INDEX+=1
    set /a FILE_NUM+=1
    
    if !FILE_NUM! EQU 20 (
        set /a CURRENT_KIT+=1
        set FILE_NUM=0
    )
)

echo.
echo ============================================
echo RESULTADO:
echo Arquivos processados: %INDEX%
echo Sucesso: %OK%
echo Erros: %ERRO%
echo Log: %LOG%
echo ============================================
echo.
pause
exit

:format_numbers
REM Formatar numero do arquivo (00-19)
if %FILE_NUM% LSS 10 (
    set FILE_NUM_STR=0%FILE_NUM%
) else (
    set FILE_NUM_STR=%FILE_NUM%
)

REM Formatar numero do kit (001-099)
if %CURRENT_KIT% LSS 10 (
    set KIT_STR=00%CURRENT_KIT%
) else (
    if %CURRENT_KIT% LSS 100 (
        set KIT_STR=0%CURRENT_KIT%
    ) else (
        set KIT_STR=%CURRENT_KIT%
    )
)
goto :eof