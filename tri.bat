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

SET /A "BN_POINTER=%~3"

SET "BN_WAVE_TR=0;1;2;3;4;5;6;7;8;9;10;11;12;13;14;15;15;14;13;12;11;10;9;8;7;6;5;4;3;2;1;0"

SET "BN_CHSTAT_TRI_PHASE=0"

SET "BN_CHREG_TRI_ENVMODE=0"
SET "BN_CHREG_TRI_LIL=0"
SET "BN_CHREG_TRI_LEL=0"
SET "BN_CHREG_TRI_TIMER=0"