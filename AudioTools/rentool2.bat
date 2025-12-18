@echo off
setlocal enabledelayedexpansion

title Renomeador WAV com Preview
color 0A

:menu
cls
echo ============================================
echo    RENOMEADOR WAV - FORMATO COM PONTO
echo ============================================
echo.
set /p BASE="Digite o nome base (ex: perc5): "
if "%BASE%"=="" set "BASE=perc5"

set /p KIT="Kit inicial (1-99): "
if "%KIT%"=="" set "KIT=1"

echo.
echo Configuracao:
echo   Nome base: %BASE%
echo   Kit inicial: %KIT%
echo.

REM Contar arquivos
set COUNT=0
for %%f in (*.wav) do set /a COUNT+=1

if !COUNT! EQU 0 (
    echo Nenhum arquivo .wav encontrado!
    pause
    exit
)

echo Encontrados !COUNT! arquivos .wav
echo.

REM Mostrar preview
echo PREVIEW DA RENOMEAcaO:
echo -----------------------
set NUM=1
set COUNT_IN_KIT=0
set CURRENT_KIT=%KIT%
set TOTAL_SHOWN=0

for %%f in (*.wav) do (
    REM Formatar numeros
    if !NUM! LSS 10 (
        set FILE_NUM=0!NUM!
    ) else (
        set FILE_NUM=!NUM!
    )
    
    if !CURRENT_KIT! LSS 10 (
        set KIT_NUM=00!CURRENT_KIT!
    ) else if !CURRENT_KIT! LSS 100 (
        set KIT_NUM=0!CURRENT_KIT!
    ) else (
        set KIT_NUM=!CURRENT_KIT!
    )
    
    set NEW_NAME=!BASE!.!FILE_NUM!_kit!KIT_NUM!_16bit_mono.wav
    
    echo %%f
    echo   --^> !NEW_NAME!
    echo.
    
    set /a NUM+=1
    set /a COUNT_IN_KIT+=1
    set /a TOTAL_SHOWN+=1
    
    if !COUNT_IN_KIT! EQU 20 (
        set /a CURRENT_KIT+=1
        set NUM=1
        set COUNT_IN_KIT=0
    )
    
    if !TOTAL_SHOWN! EQU 30 (
        echo ... (mostrando apenas primeiros 30)
        goto confirmar
    )
)

:confirmar
echo.
choice /C SN /M "Deseja renomear os arquivos (S/N)?"
if errorlevel 2 goto cancelar

echo.
echo Renomeando arquivos...
echo.

REM Executar renomeacao
set NUM=1
set COUNT_IN_KIT=0
set CURRENT_KIT=%KIT%
set TOTAL=0
set SUCESSO=0
set FALHA=0

for %%f in (*.wav) do (
    REM Formatar numeros
    if !NUM! LSS 10 (
        set FILE_NUM=0!NUM!
    ) else (
        set FILE_NUM=!NUM!
    )
    
    if !CURRENT_KIT! LSS 10 (
        set KIT_NUM=00!CURRENT_KIT!
    ) else if !CURRENT_KIT! LSS 100 (
        set KIT_NUM=0!CURRENT_KIT!
    ) else (
        set KIT_NUM=!CURRENT_KIT!
    )
    
    set NEW_NAME=!BASE!.!FILE_NUM!_kit!KIT_NUM!_16bit_mono.wav
    
    REM Renomear
    ren "%%f" "!NEW_NAME!"
    
    if exist "!NEW_NAME!" (
        echo OK: !NEW_NAME!
        set /a SUCESSO+=1
    ) else (
        echo ERRO: %%f
        set /a FALHA+=1
    )
    
    set /a NUM+=1
    set /a COUNT_IN_KIT+=1
    set /a TOTAL+=1
    
    if !COUNT_IN_KIT! EQU 20 (
        set /a CURRENT_KIT+=1
        set NUM=1
        set COUNT_IN_KIT=0
    )
)

echo.
echo ============================================
echo RESULTADO:
echo Total: !TOTAL! arquivos
echo Sucesso: !SUCESSO!
echo Falhas: !FALHA!
echo ============================================
pause
exit

:cancelar
echo Operacao cancelada.
pause
exit