@ECHO OFF
SETLOCAL ENABLEDELAYEDEXPANSION

:: SOFTWARE INFORMATIONS ::
SET "BN_SWNAME=BATNSF"
SET "BN_VER=0.0.0"

:: ARGUMENT HANDLER ::
IF "%~1"=="" GOTO USAGE

IF EXIST "%~1" (
	SET "BN_VGMPATH=%~1"
) ELSE (
	GOTO USAGE
)

REM TODO : MAKE HANDLERS FOR THESE
SET "BN_WAVPATH=%~1.raw"
SET "BN_SAMPLERATE=48000"

:: GZ DETECTION
FOR /F "TOKENS=* USEBACKQ" %%A IN (`BINREADWRITE.EXE "!BN_VGMPATH!" READ 0 2`) DO IF "%%A"=="31 139" (
	ECHO ======== !BN_SWNAME! Version !BN_VER! ========
	ECHO     Copyright 2025 Heemin
	ECHO Error : Can't unarchive vgz formats.
	EXIT /B 2
)

:: VGM DETECTION
:: - MAGIC NUMBER DETECTION
FOR /F "TOKENS=* USEBACKQ" %%A IN (`BINREADWRITE.EXE "!BN_VGMPATH!" READ 0 4`) DO IF NOT "%%A"=="86 103 109 32" (
	ECHO ======== !BN_SWNAME! Version !BN_VER! ========
	ECHO     Copyright 2025 Heemin
	ECHO Error : File is not VGM format.
	EXIT /B 2
)
:: - NES WAS ADDED ON VGM VERSION 1.61
FOR /F "TOKENS=1,2 USEBACKQ" %%A IN (`BINREADWRITE.EXE "!BN_VGMPATH!" READ 8 2`) DO (
	SET /A "TEMPVARI01=(%%B << 8) | %%A"
	IF !TEMPVARI01! LSS 353 (
		ECHO ======== !BN_SWNAME! Version !BN_VER! ========
		ECHO     Copyright 2025 Heemin
		ECHO Error : Only supports VGM version above 1.61.
		EXIT /B 2
	)
)
:: - NES DETECTION
FOR /F "TOKENS=1,2 USEBACKQ" %%A IN (`BINREADWRITE.EXE "!BN_VGMPATH!" READ 132 1`) DO IF "%%A"=="0" (
	ECHO ======== !BN_SWNAME! Version !BN_VER! ========
	ECHO     Copyright 2025 Heemin
	ECHO Error : NES isn't enabled.
	EXIT /B 2
)

GOTO PROGRESS

:USAGE
ECHO ======== !BN_SWNAME! Version !BN_VER! ========
ECHO     Copyright 2025 Heemin
ECHO Usage:
ECHO     %~nx0 [VGM / VGZ file path]
EXIT /B 0

:PROGRESS