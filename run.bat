@echo off
setlocal enabledelayedexpansion

REM Ask for user information in the specified order
set /p customer="Enter customer name: "
set /p project="Enter project name: "
set /p desc="Enter project description: "
set /p startTime="Enter start time (HH:mm): "
set /p endTime="Enter end time (HH:mm): "
set /p date="Enter date (YYYY-MM-DD): "
set /p user="Enter user name (inatials): "

REM Calculate duration
call :TimeToMinutes !startTime! startMinutes
call :TimeToMinutes !endTime! endMinutes
set /a durationMinutes=endMinutes-startMinutes

REM Convert duration back to HH:mm format
set /a hours=durationMinutes/60
set /a minutes=durationMinutes %% 60

REM Format hours and minutes with leading zeros
if %hours% lss 10 set hours=0%hours%
if %minutes% lss 10 set minutes=0%minutes%

set duration=!hours!:!minutes!

REM Print registration details
echo Registration Details:
echo Customer: %customer%
echo Project: %project%
echo Description: %desc%
echo Start Time: %startTime%
echo Duration: %duration%
echo End Time: %endTime%
echo Date: %date%
echo User: %user%

REM Ask for confirmation
set /p confirm="Is the information correct? (Y/N): "
if /i "%confirm%" neq "Y" (
    echo Incorrect Data >> log.txt
    echo - Customer: %customer% >> log.txt
    echo - Project: %project% >> log.txt
    echo - Description: %desc% >> log.txt
    echo - Start Time: %startTime% >> log.txt
    echo - Duration: %duration% >> log.txt
    echo - End Time: %endTime% >> log.txt
    echo - Date: %date% >> log.txt
    echo - User: %user% >> log.txt
    echo. >> log.txt
    echo Incorrect data saved to log.txt.
    pause
    exit /b
) else (
    REM Log registration details to log.txt
    echo Correct Data >> log.txt
    echo - Customer: %customer% >> log.txt
    echo - Project: %project% >> log.txt
    echo - Description: %desc% >> log.txt
    echo - Start Time: %startTime% >> log.txt
    echo - Duration: %duration% >> log.txt
    echo - End Time: %endTime% >> log.txt
    echo - Date: %date% >> log.txt
    echo - User: %user% >> log.txt
    echo. >> log.txt
    echo Correct data saved to log.txt.
)

@REM REM Ask if user wants to save to CSV
@REM set /p saveCSV="Do you want to save this information to CSV? (Y/N): "
@REM if /i "%saveCSV%" equ "Y" (
@REM     echo Customer, Project, Description, Start Time, End Time, Date, Duration >> data.csv
@REM     echo %customer%, %project%, %desc%, %startTime%, %endTime%, %date%, %duration% >> data.csv
@REM     echo Information saved to data.csv.
@REM )

REM Save to SQL file
set /p saveSQL="Do you want to save this information to SQL? (Y/N): "
if /i "%saveSQL%" equ "Y" (
    set "insertSQL=INSERT INTO `tasks` (`customer`, `titel`, `description`, `start`, `duration`, `end`, `date`, `collaborators`) VALUES ("
    set "closingSQL=);"
    (
        echo !insertSQL!
        echo "%customer%", "%project%", "%desc%", "%startTime%", "%duration%", "%endTime%", "%date%", "%user%"
        echo !closingSQL!
    ) >> db.sql
    echo. >> db.sql
)

pause
exit /b

:TimeToMinutes
set "time=%1"
for /f "tokens=1-2 delims=:" %%a in ("!time!") do (
    set /a hours=10%%a%%100, minutes=10%%b%%100
)
set /a result=hours*60 + minutes
endlocal & set %2=%result%
exit /b
