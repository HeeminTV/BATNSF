@ECHO OFF
SETLOCAL ENABLEDELAYEDEXPANSION

:: LICENCE TEXT ::

:: Copyright (C) 2025 Heemin

:: This program is free software; you can redistribute it and/or
:: modify it under the terms of the GNU General Public License
:: as published by the Free Software Foundation; either version 2
:: of the License, or (at your option) any later version.

:: This program is distributed in the hope that it will be useful,
:: but WITHOUT ANY WARRANTY; without even the implied warranty of
:: MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
:: GNU General Public License for more details.

:: You should have received a copy of the GNU General Public License
:: along with this program; if not, see <https://www.gnu.org/licenses/>.

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
SET "BN_SAMPLERATE=44100"

:: GZ DETECTION ::
FOR /F "TOKENS=* USEBACKQ" %%A IN (`BINREADWRITE.EXE "!BN_VGMPATH!" READ 0 2`) DO IF "%%A"=="31 139" (
	ECHO ======== !BN_SWNAME! Version !BN_VER! ========
	ECHO     Copyright 2025 Heemin
	ECHO Error : Can't unarchive vgz formats.
	EXIT /B 2
)

:: VGM DETECTION ::
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
FOR /F "TOKENS=1 USEBACKQ" %%A IN (`BINREADWRITE.EXE "!BN_VGMPATH!" READ 132 1`) DO IF "%%A"=="0" (
	ECHO ======== !BN_SWNAME! Version !BN_VER! ========
	ECHO     Copyright 2025 Heemin
	ECHO Error : NES isn't enabled.
	EXIT /B 2
)
:: OFFSET CACULATION ::
FOR /F "TOKENS=1 USEBACKQ" %%A IN (`BINREADWRITE.EXE "!BN_VGMPATH!" READ 52 1`) DO SET /A "BN_POINTER=%%A + 0x34"

:: RESET CHANNEL STATUS ::

SET "BN_CHREG_NOI_ENVMODE=0"
SET "BN_CHREG_NOI_CV=0"
SET "BN_CHREG_NOI_VOL=0"
SET "BN_CHREG_NOI_PERIOD=0"
SET "BN_CHREG_NOI_LEL=0"
SET "BN_CHREG_NOI_MODE=0"

SET "BN_CHSTAT_DMC_YPOS=0"
SET "BN_CHSTAT_DMC_IPOS=0"

SET "BN_CHREG_DMC_FREQ=15"
SET "BN_CHREG_DMC_LOOP=0"
SET "BN_CHREG_DMC_SADR=0"
SET "BN_CHREG_DMC_SLEN=0"
SET "BN_CHREG_DMC_OUT=0"

GOTO PROCESS

:USAGE
ECHO ======== !BN_SWNAME! Version !BN_VER! ========
ECHO     Copyright 2025 Heemin
ECHO Usage:
ECHO     %~nx0 [VGM / VGZ file path]
EXIT /B 0

:PROCESS
ECHO COMMAND START POINT : !BN_POINTER!
REM START PULSE.BAT !BN_VGMPATH! 1 !BN_POINTER!
REM START PULSE.BAT !BN_VGMPATH! 2 !BN_POINTER!
REM START TRI.BAT !BN_VGMPATH! !BN_POINTER!
EXIT /B 0