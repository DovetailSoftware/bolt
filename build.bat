@echo off
SET DIR=%~d0%~p0%

"%DIR%\tools\nant\nant.exe" -f:bolt.build %*
